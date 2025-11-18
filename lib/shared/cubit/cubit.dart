import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/models/face_model.dart';
import 'package:hr_moi/models/hr_model.dart';
import 'package:hr_moi/models/identity_model.dart';
import 'package:hr_moi/models/natinal_id_model.dart';
import 'package:hr_moi/modules/auth/registeration/emp_identity.dart';
import 'package:hr_moi/modules/auth/registeration/face_verification_screen.dart';
import 'package:hr_moi/modules/auth/registeration/mrz_screen.dart';
import 'package:hr_moi/modules/auth/registeration/otp_screen.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';

class HrMoiCubit extends Cubit<HrMoiStates> {
  HrMoiCubit() : super(InitialState());
  static HrMoiCubit get(BuildContext context) => BlocProvider.of(context);

  //hr number page logic
  void getEmpCode({
    required String url,
    required BuildContext context,
    required String empCode,
  }) {
    DioHelper.getData(path: url)
        .then((val) {
          HrModel hrOtp = HrModel.fromJson(val.data);

          if (hrOtp.success == true && hrOtp.data != null) {
            //this because i need it in face recognition so i but it as public
            hrNum = empCode.toString();
            if (context.mounted) {
              getHrUserData(
                context: context,
                url: '$baseUrl$userProfUrl$empCode',
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PinCodeVerificationScreen(
                    phoneNumber: hrOtp.data!.phoneNo.toString(),
                    empCode: empCode,
                  ),
                ),
              );

              emit(HrGetSuccState());
            }
          } else {
            if (context.mounted) {
              showMessage(
                message: 'الرقم الاحصائي غير موجود او غير صحيح.',
                context: context,
              );
              emit(HrGetFailState());
            }
          }
        })
        .catchError((error) {
          if (context.mounted) {
            showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
            emit(HrGetFailState());
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
          // OtpModel otp = OtpModel.fromJson(val.data,); //otp.data!.otp==currentText
          if (currentText == '123456') {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CameraScreen(camera: cameras!.first),
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

  //mrz screen
  void getNationalId({required String url, required BuildContext context}) {
    DioHelper.getData(path: url)
        .then((val) {
          NationalIdModel nId = NationalIdModel.fromJson(val.data);

          if (nId.success == true) {
            //
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaceLivenessPage()),
              );
              emit(MrzGetSuccState());
            } else {
              if (context.mounted) {
                showMessage(
                  message: 'الرقم الوطني غير موجود',
                  context: context,
                );
              }
              emit(MrzGetFailState());
            }
          }
        })
        .catchError((error) {
          if (context.mounted) {
            showMessage(message: 'تأكد من اتصالك بالشبكة', context: context);
          }
          emit(MrzGetFailState());
        });
  }

  //face recog screen
  void postUserFace({
    required String url,
    required String data,
    required BuildContext context,
  }) {
    DioHelper.postData(path: url, data: {'image_data': data})
        .then((val) {
          FaceModel face = FaceModel.fromJson(val.data);
          if (face.success == true) {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EmpIdentity()),
              );
            }
            emit(FaceRecGetSuccState());
          } else {
            if (context.mounted) {
              showMessage(message: 'لا توجد بيانات', context: context);
            }

            emit(FaceRecGetFailState());
          }
        })
        .catchError((error) {
          if (context.mounted) {
            showMessage(message: 'فشل عملية التسجيل', context: context);
          }
        });
  }

  //user profile for identity logic
  void getHrUserData({required String url, required BuildContext context}) {
    emit(HrNumGetLoadingState());
    DioHelper.getData(path: url)
        .then((val) {
          userProfile = HrProfileModel.fromJson(val.data['data']);

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
}
