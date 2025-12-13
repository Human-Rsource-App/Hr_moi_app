import 'package:flutter/material.dart';
import 'package:hr_moi/generated/assets.dart';
import 'package:hr_moi/shared/components/components.dart';

import '../../shared/style/color.dart';

class HomeScreen extends StatefulWidget
{
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
    @override
    Widget build(BuildContext context)
    {
        Size size = MediaQuery.of(context).size;
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
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                color: Color(0xff123456),
                                child: Column(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                        Row(
                                            children: <Widget>[
                                                defaultCircleAvatar(radius: 44, child: Image.asset(Assets.iconsPersonalimage), backgroundColor: Colors.black45)
                                                , Expanded(
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        spacing: 10,
                                                        children: <Widget>[
                                                            defaultContainer(child: Image.asset(Assets.iconsGuideLogo, width: 8, height: 8, fit: BoxFit.none)),
                                                            defaultContainer(child: Image.asset(Assets.iconsNotifyLogo, width: 8, height: 8, fit: BoxFit.none)),
                                                            defaultContainer(child: Image.asset(Assets.iconsModeLogo, width: 8, height: 8, fit: BoxFit.none))

                                                        ]
                                                    )
                                                )

                                            ]
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                            child: defaultContainer(
                                                width: size.width,
                                                padding: 15,
                                                child: Row(
                                                    children: <Widget>[
                                                        item(context: context, title: 'المهام المكتملة', subTitle: '12'),
                                                        defaultDivider(),
                                                        item(context: context, title: 'المهام المفتوحة', subTitle: '12'),
                                                        defaultDivider(),
                                                        item(context: context, title: 'عاجل', subTitle: '12', color: secondColor)
                                                    ]
                                                ))
                                        )
                                    ]
                                )
                            )
                        )
                    )
                ))
        );
    }
}
