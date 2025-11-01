import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/style/color.dart';

class EmpIdentity extends StatefulWidget {
  const EmpIdentity({super.key});

  @override
  State<EmpIdentity> createState() => _EmpIdentityState();
}

class _EmpIdentityState extends State<EmpIdentity> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            _showErrorDialog(context);
          },
        ),
      ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            defaultCard(
              context: context,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: defaultCircleAvatar(
                        radius: 50,
                        backgroundColor: backgColor,
                        child: Image.asset('assets/icons/moi.png'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'الهوية الرقمية',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 5),
                     Center(
                      child: Text(
                        'المعلومات الشخصية',
                        style: TextTheme.of(context).labelMedium,
                      ),
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      color: Colors.grey,
                      indent: 16,
                      endIndent: 16,
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildInfoColumn('الاسم الكامل', 'احمد علي حسين علي'),
                    const SizedBox(height: 10),
                    _buildInfoColumn(
                    const SizedBox(height: 10),
                    _buildInfoColumn('رقم الهاتف', '07712345678'),
                    const SizedBox(height: 10),
                    _buildInfoColumn('الصنف', 'ضابط'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            defaultButton(
              context: context,
              lable: 'استمرار',
              onPressed: _isChecked ? () {} : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: backgColor, width: 4),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
      ],
    );
  }
}
