import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart' hide showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

import '../../../generated/assets.dart';
import '../../../shared/components/components.dart';
import '../../../shared/style/color.dart';
import 'face_verification_screen.dart';

class EmpIdentity extends StatefulWidget
{
    const EmpIdentity({super.key});

    @override
    State<EmpIdentity> createState() => _EmpIdentityState();
}

class _EmpIdentityState extends State<EmpIdentity>
{
    @override
    Widget build(BuildContext context)
    {
        final Size size = MediaQuery.of(context).size;
        TextTheme font = TextTheme.of(context);
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: backGrColor,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    width: size.width,
                    height: size.height,

                    child: SafeArea(child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: BlocProvider(
                                create: (context) => HrMoiCubit()..getHrUserData(url: '$baseUrl$userProfUrl$hrNum', context: context),
                                child: BlocConsumer<HrMoiCubit, HrMoiStates>(
                                    listener: (context, state)
                                    {
                                        // TODO: implement listener
                                    },
                                    builder: (context, state)
                                    {
                                        return ConditionalBuilder(condition: state is ! HrNumGetLoadingState,
                                            builder: (context)=> SingleChildScrollView(
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        margin: EdgeInsets.all(8.0),
                                                        padding: EdgeInsets.all(10.0),
                                                        width: size.width,
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(colors: backGrColor),
                                                            boxShadow: [BoxShadow(color: Color(0xFF5DBBDB), blurRadius: 10, blurStyle: BlurStyle.normal, offset: Offset(0, 0))],
                                                            borderRadius: BorderRadius.circular(20.0)
                                              
                                                        ),
                                                        child: Column(
                                                            spacing: 5.0,
                                                            children: [
                                                              defaultCircleAvatar(radius: 50.0, child: Image.asset(Assets.iconsPersonalimage), backgroundColor: Colors.transparent),
                                                              SizedBox(height: 20.0),
                                                              Text('الهوية الرقمية', style: font.bodySmall!.copyWith(color: Colors.grey)),
                                                              Text('معلومات الهوية الرقمية', style: font.bodySmall)
                                                            ]
                                                        )),
                                              
                                                    SizedBox(height: 30.0),
                                                    Column(
                                                        spacing: 10.0,
                                                        children: <Widget>[
                                                          textContainer(context: context, label: 'الرقم الأحصائي', data: userProfile.data!.empCode.toString(), image: Assets.userProfileHrNo),
                                                          textContainer(context: context, label: 'الرتبة/الدرجة الوظيفية', data:userProfile.data!.rankName.toString() , image: Assets.userProfileRank),
                                                          textContainer(context: context, label: 'الاسم الكامل', data: userProfile.data!.empName.toString(), image: Assets.userProfilePersonalName),
                                                          textContainer(context: context, label: 'جهة الانتساب', data: userProfile.data!.unitName.toString(), image: Assets.userProfileWorkName),
                                                          textContainer(context: context, label: 'رقم الهاتف', data: userProfile.data!.phoneNo.toString(), image: Assets.userProfilePhone),
                                                          textContainer(context: context, label: 'نوع الفئة', data: userProfile.data!.rkTypeName.toString(), image: Assets.userProfileGroupName)
                                              
                                                        ]
                                                    )
                                                  ]
                                              ),
                                            ),
                                            fallback:(context)=> SizedBox(
                                              width: size.width,
                                                height: size.height,
                                                child: Center(child: CircularProgressIndicator(color: secondColor,))));
                                    }
                                )
                            )
                        ))
                ),
                bottomNavigationBar: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: backGrColor
                        )
                    ),
                    child: Column(
                        spacing: 5.0,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text('هل المعلومات صحيحة؟', style: font.bodySmall),

                            SizedBox(height: 10.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                    defaultButton(context: context, onPressed: ()
                                        {
                                          showDefaultDialog(context: context);
                                        }
                                        , lable: 'كلا', width: 90.0, color: Color(0XFFF44141), fontColor: Colors.white),
                                    defaultButton(context: context, onPressed: ()
                                        {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) => FaceLivenessPage()
                                              )
                                          );

                                        }
                                        , lable: 'نعم', width: 90.0, color: Color(0XFF4DB8D8), fontColor: Colors.white)
                                ]
                            )

                        ]
                    )
                )

            )
        );
    }
}
