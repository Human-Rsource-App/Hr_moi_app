import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/generated/assets.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

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
        return BlocConsumer<HrMoiCubit, HrMoiStates>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    HrMoiCubit cubit=HrMoiCubit.get(context);
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
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: SingleChildScrollView(
                                child: Column(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                                defaultCircleAvatar(radius: 44, child: Image.asset(Assets.iconsPersonalimage), backgroundColor: Colors.black45)
                                                //App bar ================================================================================================================
                                                , Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.max,
                                                    spacing: 10,
                                                    children: <Widget>[
                                                        defaultContainer(child: Image.asset(Assets.iconsGuideLogo, width: 8, height: 8, fit: BoxFit.none)),
                                                        defaultContainer(child: Image.asset(Assets.iconsNotifyLogo, width: 8, height: 8, fit: BoxFit.none)),
                                                        defaultContainer(child: Image.asset(Assets.iconsModeLogo, width: 8, height: 8, fit: BoxFit.none))
                                                    ]
                                                )

                                            ]
                                        ),
                                        //Second container===========================================================================================================
                                        defaultContainer(
                                            width: size.width,
                                            height: 90,
                                            vertPadding: 15,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                spacing: 10,
                                                children: <Widget>[
                                                    item(context: context, title: 'المهام المكتملة', subTitle: '12'),
                                                    defaultDivider(),
                                                    item(context: context, title: 'المهام المفتوحة', subTitle: '5'),
                                                    defaultDivider(),
                                                    item(context: context, title: 'عاجل', subTitle: '1', subColor: secondColor)
                                                ]
                                            )),
                                        //Second container==========================================================================================================
                                        defaultContainer(
                                            width: size.width,
                                            vertPadding: 15,
                                            height: 200,
                                            opacity: 1,
                                            color: 0xff133245,
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Column(
                                                    spacing: 10,
                                                    children: <Widget>[
                                                        Text('المعلومات الإدارية', style: TextTheme.of(context).bodySmall),
                                                        Table(
                                                            border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey, width: 2)),
                                                            columnWidths: const <int, TableColumnWidth>
                                                            {
                                                                0: FlexColumnWidth()
                                                            },
                                                            children: [
                                                                TableRow(
                                                                    children: <Widget>[
                                                                        Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: 7),
                                                                            height: 64, child: item(context: context, title: 'تاريخ آخر رتبة', subTitle: '2025/10/10', titleColor: secondColor, subTitleSize: 14)),
                                                                        Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: 7),
                                                                            height: 64, child: item(context: context, title: 'آخر علاوة', subTitle: '2025/10/10', titleColor: secondColor, subTitleSize: 14))
                                                                    ]
                                                                ),
                                                                TableRow(
                                                                    children: <Widget>[
                                                                        Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                                                                            height: 64, child: item(context: context, title: 'آخر إجازة', subTitle: '2025/10/10', titleColor: secondColor, subTitleSize: 14)),
                                                                        Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                                                                            height: 64, child: item(context: context, title: 'رصيد الإجازة الحالي', subTitle: '3 ايام', titleColor: secondColor, subTitleSize: 14))
                                                                    ]
                                                                )
                                                            ]
                                                        )

                                                    ]
                                                )
                                            )
                                        ),
                                        //===========================================================================================================================
                                        //third container
                                        defaultContainer(
                                            width: size.width,
                                            vertPadding: 15,
                                            horiPadding: 20,
                                            height: 190,
                                            opacity: 1,
                                            color: 0xff133245,
                                            child: Column(
                                                spacing: 30.0,
                                                children: <Widget>[
                                                    Text('الخدمات الإلكترونية', style: TextTheme.of(context).bodySmall),
                                                    SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                            spacing: 20.0,
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: <Widget>[
                                                                defaultContainer(child: Image.asset(Assets.appDuity, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appCalender, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appMessage, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appVacation, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appDuity, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appCalender, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appMessage, width: 8, height: 8, fit: BoxFit.none)),
                                                                defaultContainer(child: Image.asset(Assets.appVacation, width: 8, height: 8, fit: BoxFit.none))
                                                            ]
                                                        )
                                                    ),
                                                    Text('المزيد من التطبيقات...', style: TextTheme.of(context).bodySmall!.copyWith(color: secondColor))
                                                ]
                                            )
                                        ),
                                        //=======================================================================================================
                                        // news section
                                        defaultContainer(
                                            width: size.width,
                                            vertPadding: 15,
                                            horiPadding: 5,
                                            height: 700,
                                            opacity: 1,
                                            color: 0xff133245,
                                            child: Column(
                                                spacing: 20,
                                                children: <Widget>[
                                                    Text('التعاميم والبرقيات', style: TextTheme.of(context).bodySmall),
                                                    const SizedBox(height: 20),
                                                    Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                                Text('اخر الاخبار', style: TextTheme.of(context).bodySmall),
                                                                Text('عرض الكل', style: TextTheme.of(context).bodySmall!.copyWith(color: secondColor))
                                                            ]
                                                        )
                                                    ),
                                                  ListView.separated(itemBuilder: (context,int index)=>  defaultContainer(
                                                      vertPadding: 15,
                                                      horiPadding: 15,
                                                      height: 120,
                                                      width: size.width,
                                                      child: Row(
                                                        spacing: 10,
                                                        children: <Widget>[
                                                          defaultContainer(
                                                              width: 60,
                                                              height: 60,
                                                              child: Image.asset(Assets.iconsMoi, width: 8, height: 8, fit: BoxFit.cover)),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <
                                                                Widget>[
                                                              Text('برقية سريعة', style: TextTheme.of(context).bodyMedium),
                                                              Text('تاريخ الاستحقاق: 2024-01-15', style: TextTheme.of(context).bodySmall!.copyWith(color: Colors.grey)),
                                                              Text('متوسط', style: TextTheme.of(context).bodySmall!.copyWith(color: secondColor))

                                                            ],
                                                          ),
                                                        ],

                                                      )),scrollDirection: Axis.vertical,itemCount: 3,shrinkWrap: true,
                                                  separatorBuilder: (context,int index)=>SizedBox(height: 10,) ,),

                                                ]
                                            ))
                                    ]
                                )

                            )
                        )
                    )

                ),
                bottomNavigationBar: Container(
                    decoration: BoxDecoration(

                        gradient: LinearGradient(colors: backGrColor,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    child: BottomNavigationBar(items: [
                            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
                            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
                            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'التقارير')
                        ],currentIndex: cubit.curentIndex,


                    onTap: (value) {
                      cubit.changeNavBar(val: value);

                    },)
                )
            )
        );
  },
);
    }
}
