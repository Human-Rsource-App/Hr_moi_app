import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hr_moi/shared/style/color.dart';

import '../../generated/assets.dart';
import '../auth/login/login.dart';

class MoiView extends StatefulWidget {
  const MoiView({super.key});

  @override
  State<MoiView> createState() => _MoiViewState();
}

class _MoiViewState extends State<MoiView> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  transform: GradientRotation(math.pi / 7.5),
                  colors: backGrColor,
                  stops: const [0.0, 0.5, 1.0])),
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 7),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with rings
                  _buildLogo(size: size),
                  const SizedBox(height: 24),
                  // English title
                  Text('Human Resources System',
                      style: textTheme.bodyMedium!.copyWith(color: secondColor)),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, secondColor, Colors.black],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Arabic title
                  Text('ادارة ذكية للموارد البشرية',
                      style: textTheme.bodyMedium!.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo({required Size size}) {
    return Container(
      width: size.width / 1.5,
      height: size.width / 1.5,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: mainColor.withOpacity(0.2),
            width: 4,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x80FFFFFF),
                spreadRadius: 0,
                blurRadius: 10.61,
                blurStyle: BlurStyle.outer,
                offset: Offset(0, 0))
          ]),
      child: Center(
        child: Container(
          width: size.width / 1.6,
          height: size.width / 1.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: secondColor.withOpacity(0.3), width: 4),
          ),
          child: Center(
            child: Container(
              width: size.width / 1.7,
              height: size.width / 1.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: secondColor.withOpacity(0.5), width: 4),
              ),
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // Placeholder for the actual logo
                    image: DecorationImage(
                      image: AssetImage(Assets.iconsLoginLogo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
