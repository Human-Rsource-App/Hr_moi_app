import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

class HrNumber extends StatelessWidget {
  const HrNumber({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              spacing: 10.0,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text('ادخل التفاصيل', style: TextTheme.of(context).bodySmall),
                Text(
                  'أدخل رقمك الإحصائي للبدء',
                  style: TextTheme.of(
                    context,
                  ).bodySmall!.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 20),
                defaultTextField(
                  onChanged: (String val) {},
                  lable: ' الرقم الإحصائي',
                  context: context,
                  controller: controller,
                ),

                Spacer(),
                defaultButton(
                  context: context,
                  onPressed: () {},
                  lable: 'استمرار',
                ),
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
