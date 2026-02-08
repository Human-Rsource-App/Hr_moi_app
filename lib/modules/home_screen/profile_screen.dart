import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hr_moi/modules/auth/login/login.dart';
import 'package:hr_moi/shared/style/color.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../generated/assets.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../auth/login/secure_storage.dart';
class Profile extends StatefulWidget
{
    const Profile({super.key});

    @override
    State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
    String qrData = '';

    @override
    Widget build(BuildContext context) 
    {
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
                        textAlign: TextAlign.center
                    ),
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: ()
                        {
                            Navigator.of(context).pop();
                        }
                    )
                ),
                body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: backGrColor,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    width: size.width,
                    height: size.height,
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
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
                                                        offset: Offset(0, 0)
                                                    )
                                                ],
                                                borderRadius: BorderRadius.circular(20.0)
                                            ),
                                            child: Column(
                                                children: [
                                                    CacheHelper.getData(key: 'image') == null ? buildAvatar(CacheHelper.getData(key: 'image')) : defaultCircleAvatar(
                                                            radius: 50.0,
                                                            child: Image.asset(
                                                                Assets.iconsPersonalimage
                                                            ),
                                                            backgroundColor: Colors.transparent
                                                        ),
                                                    SizedBox(height: 5.0),
                                                    Text(
                                                        'الهوية الرقمية',
                                                        style: font.bodySmall!.copyWith(
                                                            color: Colors.grey
                                                        )
                                                    ),
                                                    Text(
                                                        'معلومات الهوية الرقمية',
                                                        style: font.bodySmall
                                                    )
                                                ]
                                            )
                                        ),

                                        SizedBox(height: 15.0),
                                        Column(
                                            spacing: 10,
                                            children: <Widget>[
                                                textContainer(
                                                    context: context,
                                                    label: 'الرقم الأحصائي',
                                                    data: CacheHelper.getData(key: 'empCode'),
                                                    image: Assets.userProfileHrNo
                                                ),
                                                textContainer(
                                                    context: context,
                                                    label: 'الرتبة/الدرجة الوظيفية',
                                                    data: CacheHelper.getData(key: 'rank'),
                                                    image: Assets.userProfileRank
                                                ),
                                                textContainer(
                                                    context: context,
                                                    label: 'الاسم الكامل',
                                                    data: CacheHelper.getData(key: 'empName'),
                                                    image: Assets.userProfilePersonalName
                                                ),
                                                textContainer(
                                                    context: context,
                                                    label: 'جهة الانتساب',
                                                    data: '${CacheHelper.getData(key: 'unit1')}/${CacheHelper.getData(key: 'unit2')}/${CacheHelper.getData(key: 'unit3')}',
                                                    image: Assets.userProfileWorkName
                                                ),
                                                textContainer(
                                                    context: context,
                                                    label: 'رقم الهاتف',
                                                    data: CacheHelper.getData(key: 'phone'),
                                                    image: Assets.userProfilePhone
                                                ),
                                                textContainer(
                                                    context: context,
                                                    label: 'نوع الفئة',
                                                    data: CacheHelper.getData(key: 'rankType'),
                                                    image: Assets.userProfileGroupName
                                                ),
                                                const SizedBox(height: 5),
                                                // QR Code with user data
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    child: QrImageView(
                                                        data: qrData,
                                                        version: QrVersions.auto,
                                                        size: 120.0
                                                    )
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                    child: defaultButton(context: context, onPressed: ()async
                                                        {
                                                            // await SecureStorage.clearAuth();
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                                                        }, lable: 'تسجيل  الخروج')
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                                                    child: defaultButton(context: context, onPressed: ()async
                                                        {
                                                            await SecureStorage.clearAuth();
                                                            if (context.mounted) 
                                                            {
                                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                                                            }
                                                        }, lable: 'تعطيل البصمة')
                                                )
                                            ]
                                        )
                                    ]
                                )
                            )
                        )
                    )
                )

            )
        );
    }
}
Widget buildAvatar(String image)
{
    Uint8List? imageBytes;
    if (image.isNotEmpty) 
    {
        imageBytes = base64Decode(image);
    }
    return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage:
        imageBytes != null ? MemoryImage(imageBytes) : null,
        child: imageBytes == null
            ? const Icon(Icons.person, size: 50)
            : null
    );
}
