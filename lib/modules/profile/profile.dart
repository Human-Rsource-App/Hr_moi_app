import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/style/color.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../generated/assets.dart';
import '../../shared/components/components.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String qrData = '';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    TextTheme font = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
          Text(
            'تفاصيل الهوية الرقمية',
            style: font.bodyMedium,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: backGrColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocProvider(
                create: (context) => HrMoiCubit()
                  ..getHrUserData(
                    url: '$baseUrl$userProfUrl$hrNum',
                    context: context,
                  ),
                child: BlocConsumer<HrMoiCubit, HrMoiStates>(
                  listener: (context, state) {
                    // if (userProfile.data == null) return const Center(child: Text('User data not available'));
                    // Prepare data for the QR code
                     qrData = 'الرقم الاحصائي: ${userProfile.data!.empCode}\n'
                        'الاسم: ${userProfile.data!.empName}\n'
                        'الرتبة: ${userProfile.data!.rankName}\n'
                        'جهة الانتساب: ${userProfile.data!.unitName}';
                  },
                  builder: (context, state) {


                    return ConditionalBuilder(
                      condition: state is! HrNumGetLoadingState,

                      builder: (context) => SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(8.0),
                              width: size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: backGrColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF5DBBDB),
                                    blurRadius: 10,
                                    blurStyle: BlurStyle.normal,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Column(
                                children: [
                                  defaultCircleAvatar(
                                    radius: 50.0,
                                    child: Image.asset(
                                      Assets.iconsPersonalimage,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'الهوية الرقمية',
                                    style: font.bodySmall!.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'معلومات الهوية الرقمية',
                                    style: font.bodySmall,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 15.0),
                            Column(
                              children: <Widget>[
                                textContainer(
                                  context: context,
                                  label: 'الرقم الأحصائي',
                                  data: userProfile.data!.empCode.toString(),
                                  image: Assets.iconsHrNo,
                                ),
                                textContainer(
                                  context: context,
                                  label: 'الرتبة/الدرجة الوظيفية',
                                  data: userProfile.data!.rankName.toString(),
                                  image: Assets.iconsRank,
                                ),
                                textContainer(
                                  context: context,
                                  label: 'الاسم الكامل',
                                  data: userProfile.data!.empName.toString(),
                                  image: Assets.iconsPersonalName,
                                ),
                                textContainer(
                                  context: context,
                                  label: 'جهة الانتساب',
                                  data: userProfile.data!.unit_1.toString()+'/'+ userProfile.data!.unit_2.toString()+'/'+ userProfile.data!.unit_3.toString(),
                                  image: Assets.iconsWorkName,
                                ),
                                textContainer(
                                  context: context,
                                  label: 'رقم الهاتف',
                                  data: userProfile.data!.phoneNo.toString(),
                                  image: Assets.iconsPhone,
                                ),
                                textContainer(
                                  context: context,
                                  label: 'نوع الفئة',
                                  data: userProfile.data!.rkTypeName.toString(),
                                  image: Assets.iconsGroupName,
                                ),
                                const SizedBox(height: 5),
                                // QR Code with user data
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: QrImageView(
                                    data: qrData,
                                    version: QrVersions.auto,
                                    size: 120.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      fallback: (context) => SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Center(
                          child: CircularProgressIndicator(color: secondColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}
