import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/models/login_model.dart';
import 'package:hr_moi/models/create_pass_model.dart';
import 'package:hr_moi/models/face_model.dart';
import 'package:hr_moi/models/hr_model.dart';
import 'package:hr_moi/models/identity_model.dart';
import 'package:hr_moi/models/natinal_id_model.dart';
import 'package:hr_moi/modules/auth/registeration/emp_identity.dart';
import 'package:hr_moi/modules/auth/registeration/mrz_screen.dart';
import 'package:hr_moi/modules/auth/registeration/otp_screen.dart';
import 'package:hr_moi/modules/auth/registeration/registration_success.dart';
import 'package:hr_moi/modules/auth/registeration/reset_pass/reset_success.dart';
import 'package:hr_moi/modules/home_screen/home_screen.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';
import '../../models/profile_image.dart';
import '../../modules/auth/registeration/create_pass.dart';
import '../../modules/auth/registeration/reset_pass/create_newpass.dart';
import '../../modules/auth/registeration/reset_pass/otp_reset.dart';
import '../../modules/home_screen/profile_screen.dart';
import '../network/local/cache_helper.dart';

class HrMoiCubit extends Cubit<HrMoiStates>
{
    HrMoiCubit() : super(InitialState());
    static HrMoiCubit get(BuildContext context) => BlocProvider.of(context);

    //hr number page logic
    void getEmpCode({
        required String url,
        required BuildContext context,
        required String empCode
    })
    {
        emit(HrGetLoadingState());

        DioHelper.getData(path: url).then((val)
            {
                final hrModel = HrModel.fromJson(val.data);

                if (hrModel.success == true && hrModel.msg?.actionOpr == 1)
                {
                    hrNum = empCode;

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PinCodeVerificationScreen(
                                phoneNumber: hrModel.data!.phoneNo.toString(),
                                empCode: empCode
                            )
                        )
                    );

                    emit(HrGetSuccState());
                }
                else
                {
                    if (!context.mounted) return;

                    showMessage(
                        message: 'انت تمتلك حساب مسبقاً',
                        context: context
                    );
                    emit(HrGetFailState());
                }

            }
        ).catchError((error)
                {

                    String message = 'خطأ غير معروف';

                    if (error is DioException)
                    {

                        // لا يوجد انترنت
                        if (error.type == DioExceptionType.connectionError ||
                            error.type == DioExceptionType.connectionTimeout)
                        {
                            message = 'تأكد من اتصالك بالإنترنت';
                        }

                        // رد من السيرفر مع رسالة
                        else if (error.response?.data != null)
                        {
                            dynamic data = error.response!.data;

                            if (data is String)
                            {
                                try
                                {
                                    data = jsonDecode(data);
                                }
                                catch (_)
                                {
                                }
                            }

                            if (data is Map)
                            {

                                if (data['err'] != null && data['err'].toString().isNotEmpty)
                                {
                                    message = data['err'];
                                }
                                else if (data['msg'] != null)
                                {
                                    message = data['msg'];
                                }
                            }
                        }
                    }

                    if (context.mounted)
                    {
                        showMessage(message: message, context: context);
                        emit(HrGetFailState());
                    }
                }
            );
    }

    //==============================================================================
    //otp screen logic
    void getOtp({
        required String url,
        required String currentText,
        required BuildContext context
    })
    {
      emit(OtpGetLoadingState());
        //temporary code
        // if (currentText == '123456')
        // {
        //     if (context.mounted)
        //     {
        //         Navigator.of(context).push(
        //             MaterialPageRoute(
        //                 builder: (context) => CameraScreen(camera: cameras!.last)
        //             )
        //         );
        //     }
        //     emit(OtpGetSuccState());
        // }
        //=========================================================================
        // temp
        DioHelper.getData(path: url)
            .then((val)
                {
                    // OtpModel otp = OtpModel.fromJson(val.data,); //otp.data!.otp==currentText
                    if (currentText == '123456')
                    {
                        if (context.mounted)
                        {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => CameraScreen(camera: cameras!.first)
                                )
                            );
                        }
                        emit(OtpGetSuccState());
                    }
                    else
                    {
                        if (context.mounted)
                        {
                            showMessage(
                                message: 'خطأ في ادخال الرمز المرسل!!',
                                context: context
                            );
                        }
                        emit(OtpGetFailState());
                    }
                }
            )
            .catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'لا يوجد رمز مرسل', context: context);
                                emit(OtpGetFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(OtpGetFailState());
                    }
                }
            );
    }
    //===============================================================================
    //mrz screen for nid identification
    void getNationalId({required String url, required BuildContext context})
    {
        emit(MrzGetLoadingState());
        DioHelper.getData(path: url)
            .then((val)
                {
                    NationalIdModel nId = NationalIdModel.fromJson(val.data);

                    if (nId.success == true)
                    {
                        if (context.mounted)
                        {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => EmpIdentity())
                            );
                            emit(MrzGetSuccState());
                        }
                    }
                }
            )
            .catchError((error)
                {
                    String message = 'خطأ غير معروف';
                    if (error is DioException)
                    {
                        if (error.type == DioExceptionType.connectionError ||
                            error.type == DioExceptionType.connectionTimeout)
                        {
                            message = 'تأكد من اتصالك بالإنترنت';
                        }
                        else if (error.response?.data != null)
                        {
                            dynamic data = error.response!.data;

                            if (data is String)
                            {
                                try
                                {
                                    data = jsonDecode(data);
                                }
                                catch (_)
                                {
                                }
                            }

                            if (data is Map)
                            {

                                if (data['err'] != null && data['err'].toString().isNotEmpty)
                                {
                                    message = data['err'];
                                }
                                else if (data['msg'] != null)
                                {
                                    message = data['msg'];
                                }
                            }
                        }
                    }

                    if (context.mounted)
                    {
                        showMessage(message: message, context: context);
                        emit(MrzGetFailState());
                    }
                }
            );
    }

    //==============================================================================
    //user profile for identity logic
    void getHrUserData({required String url, required BuildContext context})
    {
        emit(UserProfLoadingState());
        DioHelper.getData(path: url)
            .then((val)
                {

                    userProfile = HrProfileModel.fromJson(val.data);
                    if (userProfile.success == true && userProfile.data != null)
                    {
                      CacheHelper.saveData(key: 'image', value: userProfile.data!.imageBase64.toString());
                      CacheHelper.saveData(key: 'empCode', value: userProfile.data!.empCode.toString());
                      CacheHelper.saveData(key: 'rank', value: userProfile.data!.rankName.toString());
                      CacheHelper.saveData(key: 'empName', value: userProfile.data!.empName.toString());
                      CacheHelper.saveData(key: 'unit', value: userProfile.data!.unitName.toString());
                      CacheHelper.saveData(key: 'phone', value: userProfile.data!.phoneNo.toString());
                      CacheHelper.saveData(key: 'rankType', value: userProfile.data!.rkTypeName.toString());
                      CacheHelper.saveData(key: 'unit1', value: userProfile.data!.unit1.toString());
                      CacheHelper.saveData(key: 'unit2', value: userProfile.data!.unit2.toString());
                      CacheHelper.saveData(key: 'unit3', value: userProfile.data!.unit3.toString());
                        emit(UserProfSuccState());
                    }
                    else 
                    {
                        emit(UserProfFailState());
                    }

                }
            )
            .catchError((error)
                {
                  String message = 'خطأ غير معروف';

                  if (error is DioException)
                  {
                    if (error.type == DioExceptionType.connectionError ||
                        error.type == DioExceptionType.connectionTimeout)
                    {
                      message = 'تأكد من اتصالك بالإنترنت';
                    }
                    else if (error.response?.data != null)
                    {
                      dynamic data = error.response!.data;

                      if (data is String)
                      {
                        try
                        {
                          data = jsonDecode(data);
                        }
                        catch (_)
                        {
                        }
                      }

                      if (data is Map)
                      {

                        if (data['err'] != null && data['err'].toString().isNotEmpty)
                        {
                          message = data['err'];
                        }
                        else if (data['msg'] != null)
                        {
                          message = data['msg'];
                        }
                      }
                    }
                  }

                  if (context.mounted)
                  {
                    showMessage(message: message, context: context);
                    emit(UserProfFailState());
                  }
                }
            );
    }
    //==============================================================================
    //face recog screen
    void postUserFace({
        required String url,
        required String data,
        required BuildContext context
    })
    {
        DioHelper.postData(path: url, data: {'image_data': data})
            .then((val)
                {
                    FaceModel face = FaceModel.fromJson(val.data);
                    if (face.success == true)
                    {
                        if (context.mounted)
                        {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => CreatePasswordScreen())
                            );
                        }
                        emit(FaceRecGetSuccState());
                    }

                }
            )
            .catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 409)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هذا المستخدم مسجل مسبقا', context: context);
                                emit(FaceRecGetFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(FaceRecGetFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(FaceRecGetFailState());
                    }
                }
            );
    }
    //==============================================================================
    //create pass
    void createPass({
        required String url,
        required String empCode,
        required String password,
        required BuildContext context
    })
    {
      emit(CreatePassLoadingState());
        DioHelper.postData(
            path: url,
            data: {"empcode": empCode, "password": password}
        )
            .then((val)
                {
                    CreatePassModel pass = CreatePassModel.fromJson(val.data);

                    if (pass.success == true)
                    {
                        //
                        if (context.mounted)
                        {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationSuccessScreen()
                                )
                            );
                            emit(CreatePassSuccState());
                        }

                    }
                }
            )
            .catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 409)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هذا المستخدم مسجل مسبقا', context: context);
                                emit(CreatePassFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(CreatePassFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(CreatePassFailState());
                    }
                }
            );
    }
    //==============================================================================
    //Login logic
    void loginData({
        required String url,
        required String empCode,
        required String password,
        required BuildContext context
    })
    {
      emit(LoginLoadingState());
        DioHelper.postData(
            path: url,
            data: {"empcode": empCode, "password": password}
        )
            .then((val)
                {
                    hrNum = empCode;
                    LoginModel loginModel = LoginModel.fromJson(val.data);

                    if (loginModel.success == true)
                    {
                        if (context.mounted)
                        {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen())
                            );
                            emit(LoginSuccState());
                        }
                    }
                }
            ).catchError((error)
        {

          String message = 'خطأ غير معروف';

          if (error is DioException)
          {
            if (error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout)
            {
              message = 'تأكد من اتصالك بالإنترنت';
            }
            else if (error.response?.data != null)
            {
              dynamic data = error.response!.data;

              if (data is String)
              {
                try
                {
                  data = jsonDecode(data);
                }
                catch (_)
                {
                }
              }

              if (data is Map)
              {

                if (data['err'] != null && data['err'].toString().isNotEmpty)
                {
                  message = data['err'];
                }
                else if (data['msg'] != null)
                {
                  message = data['msg'];
                }
              }
            }
          }

          if (context.mounted)
          {
            showMessage(message: message, context: context);
            emit(LoginFailState());
          }
        }
        );
    }
    //============================================================================
    //reset screen req to check if hr no available logic
    void checkAccount({required String path, required BuildContext context})
    {
      emit(AccountLoadingState());

      DioHelper.getData(path: path).then((val)
      {
        final hrModel = HrModel.fromJson(val.data);

        if (hrModel.success == true && hrModel.msg?.actionOpr == 2)
        {
          if (!context.mounted) return;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => OtpReset(
                      phoneNumber: hrModel.data!.phoneNo.toString(),
                      empCode: hrModel.data!.empCode.toString()
                  )
              )
          );

          emit(AccountSuccState());
        }
        else
        {
          if (!context.mounted) return;
          showMessage(
              message: 'انت لا تمتلك حساب مسبقاً',
              context: context
          );
          emit(AccountFailState());
        }

      }
      ).catchError((error)
      {

        String message = 'خطأ غير معروف';

        if (error is DioException)
        {
          if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout)
          {
            message = 'تأكد من اتصالك بالإنترنت';
          }
          else if (error.response?.data != null)
          {
            dynamic data = error.response!.data;

            if (data is String)
            {
              try
              {
                data = jsonDecode(data);
              }
              catch (_)
              {
              }
            }

            if (data is Map)
            {

              if (data['err'] != null && data['err'].toString().isNotEmpty)
              {
                message = data['err'];
              }
              else if (data['msg'] != null)
              {
                message = data['msg'];
              }
            }
          }
        }

        if (context.mounted)
        {
          showMessage(message: message, context: context);
          emit(AccountFailState());
        }
      }
      );


    }

    //===============================================================================
    //otp screen for reset pass logic
    void getOtpResetPass({
        required String url,
        required String currentText,
        required BuildContext context
    })
    {
        //temporary code
        if (currentText == '123456')
        {
            if (context.mounted)
            {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => CreateNewpass()
                    )
                );
            }
            emit(OtpRestPassSuccState());
        }
        //=========================================================================
        // temp
        DioHelper.getData(path: url)
            .then((val)
                {
                    // OtpModel otp = OtpModel.fromJson(val.data,); //otp.data!.otp==currentText
                    if (currentText == '123456')
                    {
                        if (context.mounted)
                        {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => CreateNewpass()
                                )
                            );
                        }
                        emit(OtpRestPassSuccState());
                    }
                    else
                    {
                        if (context.mounted)
                        {
                            showMessage(
                                message: 'خطأ في ادخال الرمز المرسل!!',
                                context: context
                            );
                        }
                        emit(OtpResetPassFailState());
                    }
                }
            )
            .catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'لا يوجد رمز مرسل', context: context);
                                emit(OtpResetPassFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(OtpResetPassFailState());
                    }
                }
            );
    }

    //==============================================================================
    //create new pass
    void createNewPass({
        required String url,
        required String empCode,
        required String password,
        required BuildContext context
    })
    {
      emit(CreateNewPassLoadingState());
        DioHelper.putData(
            path: url,
            data: {"empcode": empCode,"newPassword": password}
        )
            .then((val)
                {
                    CreatePassModel pass = CreatePassModel.fromJson(val.data);

                    if (pass.success == true)
                    {

                        if (context.mounted)
                        {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassSucc()
                                )
                            );
                            emit(CreateNewPassSuccState());
                        }

                    }
                }
            ).catchError((error)
        {

          String message = 'خطأ غير معروف';

          if (error is DioException)
          {
            if (error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout)
            {
              message = 'تأكد من اتصالك بالإنترنت';
            }
            else if (error.response?.data != null)
            {
              dynamic data = error.response!.data;

              if (data is String)
              {
                try
                {
                  data = jsonDecode(data);
                }
                catch (_)
                {
                }
              }

              if (data is Map)
              {

                if (data['err'] != null && data['err'].toString().isNotEmpty)
                {
                  message = data['err'];
                }
                else if (data['msg'] != null)
                {
                  message = data['msg'];
                }
              }
            }
          }

          if (context.mounted)
          {
            showMessage(message: message, context: context);
            emit(CreateNewPassFailState());
          }
        }
        );
    }
    //home screen logic ===========================================================
    int curentIndex = 1;
    void changeNavBar({required int val})
    {
        curentIndex = val;
        emit(ChangeNavBarState());
    }
    //==========================================================================
    //user profile logic
    void getProfileData({required String url, required BuildContext context})
    {
        emit(UserProfLoadingState());
        DioHelper.getData(path: url)
            .then((val)
                {

                    userProfile = HrProfileModel.fromJson(val.data);
                    if (val.data != null)
                    {
                        if (userProfile.success == true)
                        {
                            if (context.mounted)
                            {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()
                                    )
                                );
                            }
                            emit(ProfileGetSuccState());
                        }

                    }
                }
            )
            .catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'حدثت مشكله اثناء جلب البيانات', context: context);
                                emit(ProfileGetFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(ProfileGetFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(ProfileGetFailState());
                    }
                }
            );
    }
    //============================================================================
    //get profile image
    void getImageData({required String url, required BuildContext context})
    {
        DioHelper.getData(path: url)
            .then((val)
                {
                    imageProfile = ProfileImage.fromJson(val.data);
                    if (val.data != null)
                    {
                        if (imageProfile.success == true)
                        {

                            emit(GetImageSucState());
                        }

                    }
                }
            )
            .catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'حدثت مشكله اثناء جلب البيانات', context: context);
                                emit(GetImageFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(GetImageFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(GetImageFailState());
                    }
                }
            );
    }

    //============================================================================
}
