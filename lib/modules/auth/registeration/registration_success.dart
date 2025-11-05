import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            defaultCircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF69C5F8),
              child: const Icon(Icons.check, color: Colors.white, size: 80),
            ),
            const SizedBox(height: 32),
            Text(
              '!تم التسجيل بنجاح',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ' تم تسجيلك بنجاح في تطبيق خدمات وزارة الداخلية',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            defaultButton(
              context: context,
              lable: 'الدخول الى التطبيق',
              onPressed: () {
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
