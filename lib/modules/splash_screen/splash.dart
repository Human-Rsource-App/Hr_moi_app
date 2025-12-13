import 'package:flutter/material.dart';
import 'package:hr_moi/shared/style/color.dart';

class MoiView extends StatelessWidget {
  const MoiView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 7),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with rings
                  _buildLogo(),
                  const SizedBox(height: 24),
                  // English title
                  Text(
                    'Human Resources System',
                    style: textTheme.bodyMedium!.copyWith(color: secondColor),
                  ),

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
                  Text(
                    'ادارة ذكية للموارد البشرية',
                    style: textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCornerBracket({bool isTopLeft = false}) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(painter: _CornerBracketPainter(isTopLeft: isTopLeft)),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: mainColor.withOpacity(0.2), width: 4),
      ),
      child: Center(
        child: Container(
          width: 270,
          height: 270,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: secondColor.withOpacity(0.3), width: 4),
          ),
          child: Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: secondColor.withOpacity(0.5),
                  width: 4,
                ),
              ),
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // Placeholder for the actual logo
                    image: DecorationImage(
                      image: AssetImage('assets/icons/moiLogo.png'),
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

class _CornerBracketPainter extends CustomPainter {
  final bool isTopLeft;
  _CornerBracketPainter({this.isTopLeft = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = secondColor.withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (isTopLeft) {
      canvas.drawLine(const Offset(0, 0), const Offset(0, 60), paint);
      canvas.drawLine(const Offset(0, 0), const Offset(60, 0), paint);
    } else {
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, size.height - 60),
        paint,
      );
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width - 60, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
