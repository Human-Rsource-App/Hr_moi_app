import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/models/hr_profile_model.dart';
import 'package:hr_moi/modules/auth/registeration/otp_screen.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';

class HrMoiCubit extends Cubit<HrMoiStates> {
  HrMoiCubit() : super(InitialState());
  static HrMoiCubit get(BuildContext context) => BlocProvider.of(context);

  //hr screen logic
  void getHrUserData({
    required String url,
    required String hrFromTextField,
    required BuildContext context,
  }) {
    emit(HrNumGetLoadingState());
    DioHelper.getData(path: url)
        .then((val) {
          HrProfileModel userProfile = HrProfileModel.fromJson(
            val.data['data'],
          );

          if (val.data != null) {
            if (userProfile.data!.empCode == hrFromTextField) {
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PinCodeVerificationScreen(),
                  ),
                );
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
