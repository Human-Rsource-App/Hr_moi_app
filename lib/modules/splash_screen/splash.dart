import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hr_moi/shared/style/color.dart';

import '../../generated/assets.dart';
import '../auth/login/login.dart';

class MoiView extends StatefulWidget
{
    const MoiView({super.key});

    @override
    State<MoiView> createState() => _MoiViewState();
}

class _MoiViewState extends State<MoiView>
    with SingleTickerProviderStateMixin
{

    late AnimationController _controller;
    late Animation<double> _scale;

    @override
    void initState() 
    {
        super.initState();

        // نبض خفيف
        _controller = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 2)
        )..repeat(reverse: true);

        _scale = Tween<double>(
            begin: 0.95,
            end: 1.05
        ).animate(
                CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOut
                )
            );

        //go to the next page after 3 second
        Future.delayed(const Duration(seconds: 3), ()
            {
                if (!mounted) return;

                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 700),
                        pageBuilder: (_, _, _) => const Login(),
                        transitionsBuilder: (_, animation, _, child)
                        {
                            return FadeTransition(
                                opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut
                                ),
                                child: child
                            );
                        }
                    )
                );
            }
        );
    }

    @override
    void dispose() 
    {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) 
    {
        final size = MediaQuery.of(context).size;
        final textTheme = Theme.of(context).textTheme;

        return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
                body: Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            transform: GradientRotation(math.pi / 7.5),
                            colors: backGrColor,
                            stops: const[0.0, 0.5, 1.0]
                        )
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height / 7),
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    _buildLogo(size: size),
                                    const SizedBox(height: 24),
                                    Text(
                                        'Human Resources System',
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: secondColor)
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                        width: 150,
                                        height: 2,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [Colors.black, secondColor, Colors.black]
                                            )
                                        )
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                        'ادارة ذكية للموارد البشرية',
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: Colors.white)
                                    )
                                ]
                            )
                        )
                    )
                )
            )
        );
    }

    Widget _buildLogo({required Size size}) 
    {
        return Container(
            width: size.width / 1.5,
            height: size.width / 1.5,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: mainColor.withValues(alpha: 0.2),
                    width: 4
                ),
                boxShadow: const[
                    BoxShadow(
                        color: Color(0x80FFFFFF),
                        blurRadius: 10.61,
                        blurStyle: BlurStyle.outer
                    )
                ]
            ),
            child: Center(
                child: Container(
                    width: size.width / 1.6,
                    height: size.width / 1.6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: secondColor.withValues(alpha: 0.3),
                            width: 4
                        )
                    ),
                    child: Center(
                        child: Container(
                            width: size.width / 1.7,
                            height: size.width / 1.7,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: secondColor.withValues(alpha: 0.5),
                                    width: 4
                                )
                            ),
                            child: Center(
                                child: ScaleTransition(
                                    scale: _scale,
                                    child: Container(
                                        width: size.width / 1.9,
                                        height: size.width / 1.9,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(Assets.iconsMainLogo),
                                                fit: BoxFit.cover
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        );
    }
}
