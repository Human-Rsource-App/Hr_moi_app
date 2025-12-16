import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/models/login_model.dart';
import 'package:hr_moi/models/register_model.dart';
import 'package:hr_moi/models/face_model.dart';
import 'package:hr_moi/models/hr_model.dart';
import 'package:hr_moi/models/identity_model.dart';
import 'package:hr_moi/models/natinal_id_model.dart';
import 'package:hr_moi/modules/auth/registeration/emp_identity.dart';
import 'package:hr_moi/modules/auth/registeration/mrz_screen.dart';
import 'package:hr_moi/modules/auth/registeration/otp_screen.dart';
import 'package:hr_moi/modules/auth/registeration/registration_success.dart';
import 'package:hr_moi/modules/home_screen/home_screen.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';
import '../../models/reset_pass/reset_req_model.dart';
import '../../modules/auth/registeration/create_pass.dart';
import '../../modules/auth/registeration/reset_pass/create_newpass.dart';
import '../../modules/auth/registeration/reset_pass/otp_reset.dart';

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
        DioHelper.getData(path: url)
            .then((val)
                {
                    HrModel hrOtp = HrModel.fromJson(val.data);

                    if (hrOtp.success == true && hrOtp.data != null)
                    {
                        //this because i need it in face recognition so i but it as public
                        hrNum = empCode.toString();
                        if (context.mounted)
                        {
                            // getHrUserData(
                            //     context: context,
                            //     url: '$baseUrl$userProfUrl$empCode'
                            // );
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PinCodeVerificationScreen(
                                        phoneNumber: hrOtp.data!.phoneNo.toString(),
                                        empCode: empCode
                                    )
                                )
                            );

                            emit(HrGetSuccState());
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
                                emit(HrGetFailState());
                            }
                        }
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(
                                    message: 'الرقم الاحصائي غير موجود او غير صحيح.',
                                    context: context
                                );
                                emit(HrGetFailState());
                            }
                        }
                    }
                    else
                    {
                        if (context.mounted)
                        {
                            showMessage(
                                message: 'هنالك مشكله في الخادم',
                                context: context
                            );
                            emit(HrGetFailState());
                        }
                    }
                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
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
        //temporary code
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
    //mrz screen
    void getNationalId({required String url, required BuildContext context})
    {
        DioHelper.getData(path: url)
            .then((val)
                {
                    NationalIdModel nId = NationalIdModel.fromJson(val.data);

                    if (nId.success == true)
                    {
                        //
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
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'الرقم الوطني غير موجود.حدث معلوماتك في نظام HR', context: context);
                                emit(MrzGetFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(MrzGetFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(MrzGetFailState());
                    }
                }
            );
    }

    //==============================================================================
    //user profile for identity logic
    void getHrUserData({required String url, required BuildContext context})
    {
        emit(HrNumGetLoadingState());
        DioHelper.getData(path: url)
            .then((val)
                {

                    userProfile = HrProfileModel.fromJson(val.data);
                    if (val.data != null)
                    {
                        if (userProfile.success == true)
                        {
                            emit(HrNumGetSuccState());
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
                                showMessage(message: 'الرقم الوطني غير موجود.حدث معلوماتك في نظام HR', context: context);
                                emit(MrzGetFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(MrzGetFailState());
                            }
                        }
                    }

                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(MrzGetFailState());
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
        DioHelper.postData(
            path: url,
            data: {"empcode": empCode, "password": password}
        )
            .then((val)
                {
                    LoginModel pass = LoginModel.fromJson(val.data);

                    if (pass.success == true)
                    {
                        //
                        if (context.mounted)
                        {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen())
                            );
                            emit(LoginSuccState());
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(
                                    message: 'هذا المستخدم غير موجود',
                                    context: context
                                );
                            }
                            emit(LoginFailState());
                        }
                    }
                }
            )
            .catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'خطا في الباسورد المدخل', context: context);
                    }
                    emit(LoginFailState());
                }
            );
    }
    //============================================================================
    //reset screen logic
    void resetPass({required String path, required Map<String, dynamic> data, required BuildContext context})
    {
        DioHelper.postData(path: path, data: data).then((val)
            {
                ResetReqModel data = ResetReqModel.fromJson(val.data);
                if (data.success == true)
                {
                    if (context.mounted)
                    {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => OtpReset(empCode: data.data!.empCode!, phoneNumber: data.data!.phone!))
                        );
                        emit(ResetPassSuccState());
                    }
                }
            }
        ).catchError((error)
                {
                    if (error is DioException)
                    {
                        if (error.response!.statusCode == 404)
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هذا المستخدم غير موجود', context: context);
                                emit(ResetPassFailState());
                            }
                        }
                        else
                        {
                            if (context.mounted)
                            {
                                showMessage(message: 'هنالك مشكلة في الخادم', context: context);
                                emit(ResetPassFailState());
                            }
                        }
                    }
                }
            ).catchError((error)
                {
                    if (context.mounted)
                    {
                        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
                        emit(ResetPassFailState());
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
    required String otp,
    required String password,
    required BuildContext context
  })
  {
    DioHelper.postData(
        path: url,
        data: {"empCode": empCode,"otp":otp, "newPassword": password}
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
          emit(CreateNewPassSuccState());
        }

      }
    }
    )
        .catchError((error)
    {
      if (error is DioException)
      {
        if (error.response!.statusCode == 400)
        {
          if (context.mounted)
          {
            showMessage(message: 'OTP غير صحيح أو منتهي', context: context);
            emit(CreateNewPassFailState());
          }
        }
        else
        {
          if (context.mounted)
          {
            showMessage(message: '$errorهنالك مشكلة في الخادم', context: context);
            emit(CreateNewPassFailState());
          }
        }
      }

    }
    ).catchError((error)
    {
      if (context.mounted)
      {
        showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
        emit(CreateNewPassFailState());
      }
    }
    );
  }
  //home screen logic ===========================================================
  int curentIndex=1;
    void changeNavBar({required int val}){
      curentIndex=val;
      emit(ChangeNavBarState());
    }
}
