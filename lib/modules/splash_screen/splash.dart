import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:heexacolor/heexacolor.dart';
import 'package:hr_moi/modules/auth/registeration/hr_number.dart';
import 'package:hr_moi/shared/style/color.dart';

class MoiView extends StatelessWidget {
  const MoiView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: GradientRotation(math.pi / 7.5),
              colors: [
                HexColor('#155DFC'),
                HexColor('#00B8DB'),
                HexColor('#1447E6'),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 7),
            child: SingleChildScrollView(
              child: Column(
                spacing: 40.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'جمهورية العراق',
                      style: textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,

                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x80FFFFFF),
                          spreadRadius: 0,
                          blurRadius: 10.61,
                          blurStyle: BlurStyle.outer,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icons/moi.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'وزارة الداخلية',
                        style: textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 140),
                        child: Divider(),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        'نظام إدارة الموارد البشرية',
                        style: textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'إدارة متكاملة لخدمات مديرية الموارد البشرية',
                        style: textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,

          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HrNumber()),
            );
          },
          child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
