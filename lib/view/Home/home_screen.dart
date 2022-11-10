import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/const_size.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../components/indicatorWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  int pagerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          appWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.commonSizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: CommonText.textBoldWight600(
                    text: TextConst.latestMovers,
                    fontSize: 16.sp,
                    color: CommonColor.themDarkColor6E5DE7),
              ),
              CommonWidget.commonSizedBox(height: 30),
              bannerWidget(),
              PageIndicator(pagerIndex: pagerIndex, totalPages: 3),
            ],
          )
        ]),
      ),
    );
  }

  CarouselSlider bannerWidget() {
    return CarouselSlider(
        items: List.generate(3, (index) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: CommonColor.themColor9295E2,
                borderRadius: BorderRadius.circular(14)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CommonText.textBoldWight400(
                  text: 'Frame 8', color: Colors.white60),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonText.textBoldWight700(
                      text: 'TANLA PLATFORMS', color: Colors.white),
                ),
                Spacer(),
                Column(children: [
                  Row(
                    children: [
                      Image.asset(
                        ImageConst.upArrow,
                        scale: 2.8,
                      ),
                      CommonText.textBoldWight400(
                          text: '30%', color: Colors.white)
                    ],
                  ),
                  Row(
                    children: [
                      CommonText.textBoldWight400(
                          text: '28 JUL -',
                          color: Colors.white,
                          fontSize: 8.sp),
                      CommonText.textBoldWight400(
                          text: '5 AUG', color: Colors.white, fontSize: 8.sp),
                    ],
                  )
                ]),
              ]),
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight600(
                  color: Colors.white,
                  fontSize: 10.sp,
                  text:
                      "✅ Company will consider a proposal for buybac of Equity Shares on Thursday September 08, 2022"),
              CommonWidget.commonSizedBox(height: 6),
              CommonText.textBoldWight600(
                  fontSize: 10.sp,
                  color: Colors.white,
                  text:
                      "ℹ️ Buyback reflects confidence of investors and is generally  positive for stock price")
            ]),
          );
        }),
        options: CarouselOptions(
          height: 180,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          pageSnapping: true,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              pagerIndex = index;
            });
          },
          scrollDirection: Axis.horizontal,
        ));
  }

  Row appWidget() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              globalKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu_outlined,
              size: 28.sp,
              color: CommonColor.themColor9295E2,
            )),
        CommonText.textBoldWight700(text: 'Good evening  🙌', fontSize: 16.sp),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: CommonText.textBoldWight400(text: 'Login'),
          decoration: BoxDecoration(
              border: Border.all(color: CommonColor.themDarkColor6E5DE7),
              borderRadius: BorderRadius.circular(100)),
        ),
        CommonWidget.commonSizedBox(width: 10),
        Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff6E5DE7).withOpacity(0.8),
                      Color(0xff6E5DE7).withOpacity(0.8),
                    ]),
                shape: BoxShape.circle,
                color: CommonColor.themColor9295E2),
            child: Image.asset(
              'assets/png/notification.png',
              scale: 2.6,
            )),
        CommonWidget.commonSizedBox(width: 10)
      ],
    );
  }
}
