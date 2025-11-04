import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/models/hr_otp_model.dart';
import 'package:hr_moi/models/hr_profile_model.dart';
import 'package:hr_moi/models/otp_model.dart';
import 'package:hr_moi/modules/auth/registeration/mrz_screen.dart';
import 'package:hr_moi/modules/auth/registeration/otp_screen.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';

class HrMoiCubit extends Cubit<HrMoiStates> {
  HrMoiCubit() : super(InitialState());
  static HrMoiCubit get(BuildContext context) => BlocProvider.of(context);

  //empCode logic for hr screen
  void getEmpCode({
    required String url,
    required BuildContext context,
    required String empCode,
  }) {
    DioHelper.getData(path: url)
        .then((val) {
          HrOtpModel hrOtp = HrOtpModel.fromJson(val.data['data']);

          if (hrOtp.success == true && hrOtp.data != null) {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PinCodeVerificationScreen(
                    phoneNumber: hrOtp.data!.phoneNo.toString(),
                    empCode: empCode,
                  ),
                ),
              );
              emit(HrOtpGetSuccState());
            }
          } else {
            if (context.mounted) {
              showMessage(
                message: 'الرقم الاحصائي غير موجود او غير صحيح.',
                context: context,
              );
              emit(HrOtpGetFailState());
            }
          }
        })
        .catchError((error) {
          if (context.mounted) {
            showMessage(
              message: 'الرقم الاحصائي غير موجود او غير صحيح.',
              context: context,
            );
            emit(HrOtpGetFailState());
          }
        });
  }

  //otp screen logic
  void getOtp({
    required String url,
    required String currentText,
    required BuildContext context,
  }) {
    DioHelper.getData(path: url)
        .then((val) {
          OtpModel otp = OtpModel.fromJson(
            val.data,
          ); //otp.data!.otp==currentText
          if (currentText == '123456') {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CameraScreen(camera: cameras!.last),
                ),
              );
            }
            emit(OtpGetSuccState());
          } else {
            if (context.mounted) {
              showMessage(
                message: 'تأكد من رقم الرمز المرسل!!',
                context: context,
              );
            }
            emit(OtpGetFailState());
          }
        })
        .catchError((error) {
          if (context.mounted) {
            showMessage(message: 'خطأ في ادخال الرمز المرسل', context: context);
            emit(OtpGetSuccState());
          }
        });
  }

  //user profile for identity logic
  void getHrUserData({required String url, required BuildContext context}) {
    emit(HrNumGetLoadingState());
    DioHelper.getData(path: url)
        .then((val) {
          HrProfileModel userProfile = HrProfileModel.fromJson(
            val.data['data'],
          );

          if (val.data != null) {
            if (userProfile.success == true) {
              if (context.mounted) {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const PinCodeVerificationScreen(),
                //   ),
                // );

                emit(HrNumGetSuccState());
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'الرقم الاحصائي غير موجود تحقق منه مرة ثانية',
                    ),
                  ),
                );
                emit(HrNumGetFailState());
              }
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('لا توجد بيانات')));
            }
          }
          emit(HrNumGetFailState());
        })
        .catchError((err) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ في لاتصال تاكد من اتصالك بالشبكة')),
            );
          }
          emit(HrNumGetFailState());
        });
  }

  //otp screen
}
