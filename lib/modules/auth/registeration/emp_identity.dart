import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

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
    return BlocConsumer<HrMoiCubit, HrMoiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
              leading: IconButton(onPressed: (){_showErrorDialog(context);}, icon: defaultArrowBack()),
            ),
          body: Padding(
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
                              child: _buildInfoColumn(
                                'الرقم الاحصائي',
                                userProfile!.data!.empCode.toString(),
                              ),
                            ),
                            Expanded(child: _buildInfoColumn('الرتبة', 'مقدم')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInfoColumn('الاسم الكامل', 'احمد علي حسين علي'),
                        const SizedBox(height: 10),
                        _buildInfoColumn(
                          'الدائرة',
                          'مديرية الاتصالات والنظم المعلوماتية',
                        ),
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
                    Text(
                      'نعم٬ اؤكد صحة هذه المعلومات',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                 Spacer(),
                defaultButton(
                  context: context,
                  lable: 'استمرار',
                  onPressed: _isChecked ? () {} : null,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
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
                    child: defaultCircleAvatar(
                      radius: 20,
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('تحديث المعلومات', style: TextTheme.of(context).bodyLarge),
                const SizedBox(height: 10),
                Text(
                  'يرجى تحديث معلوماتك في نظام HR',
                  style: TextTheme.of(context).labelSmall,
                  textAlign: TextAlign.center,
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
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 5),
        Text(subtitle, style: TextTheme.of(context).labelSmall),
      ],
    );
  }
}
