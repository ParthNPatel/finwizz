import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/view/Home/home_screen.dart';
import 'package:finwizz/view/news/news_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List bottomItems = [
    {"icon": ImageConst.home, 'label': "Home"},
    {"icon": ImageConst.news, 'label': "News"},
    {"icon": ImageConst.portfolio, 'label': "Portfolio"},
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selected == 0
          ? HomeScreen()
          : selected == 1
              ? NewsMainScreen()
              : Center(
                  child: Text(
                    "Portfolio",
                    textScaleFactor: 1,
                  ),
                ),
      bottomNavigationBar: Container(
        height: 50.sp,
        width: double.infinity,
        color: CommonColor.geryColor1EDEDED,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            bottomItems.length,
            (index) => ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                setState(() {
                  selected = index;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    bottomItems[index]['icon'],
                    color: selected == index
                        ? CommonColor.primaryColor
                        : Color(0xff808191),
                  ),
                  SizedBox(
                    height: 3.sp,
                  ),
                  Text(
                    bottomItems[index]['label'],
                    style: TextStyle(
                      color:
                          selected == index ? Colors.black : Color(0xffA6A6A6),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}