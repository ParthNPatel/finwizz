import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/controller/handle_screen_controller.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/view/Home/home_screen.dart';
import 'package:finwizz/view/SignUp_SignIn/sign_up_screen.dart';
import 'package:finwizz/view/news/news_main_screen.dart';
import 'package:finwizz/view/notification/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../BookMark/book_mark_screen.dart';
import '../portfolio/portfolio_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final int? selectedIndex;
  const BottomNavScreen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List bottomItems = [
    {"icon": ImageConst.home, 'label': "Home"},
    {"icon": ImageConst.bellIcon, 'label': "Notification"},
    {"icon": ImageConst.news, 'label': "News"},
    {"icon": ImageConst.portfolio, 'label': "Portfolio"},
  ];

  List bottomItemsWN = [
    {"icon": ImageConst.home, 'label': "Home"},
    {"icon": ImageConst.news, 'label': "News"},
    {"icon": ImageConst.portfolio, 'label': "Portfolio"},
  ];

  int selected = 0;

  HandleScreenController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.selectedIndex!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HandleScreenController>(
        builder: (controller) =>
            GetStorageServices.getUserLoggedInStatus() == true
                ? selected == 0
                    ? HomeScreen()
                    : selected == 1
                        ? NotificationScreen()
                        : selected == 2
                            ? controller.isTapped == true
                                ? BookMarkScreen()
                                : NewsMainScreen()
                            : GetStorageServices.getUserLoggedInStatus() == true
                                ? PortfolioScreen()
                                : SignUpScreen()
                : selected == 0
                    ? HomeScreen()
                    : selected == 1
                        ? controller.isTapped == true
                            ? BookMarkScreen()
                            : NewsMainScreen()
                        : GetStorageServices.getUserLoggedInStatus() == true
                            ? PortfolioScreen()
                            : SignUpScreen(),
      ),
      bottomNavigationBar: Container(
        height: 50.sp,
        width: double.infinity,
        color: CommonColor.geryColor1EDEDED,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            GetStorageServices.getUserLoggedInStatus() == true
                ? bottomItems.length
                : bottomItemsWN.length,
            (index) => ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                print('indexxxxxx    $index');
                // if (selected == 2) {
                //   print('milannnanna ');
                // } else {
                setState(() {
                  selected = index;
                });
                // }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetStorageServices.getUserLoggedInStatus() == true
                      ? bottomItems[index]['icon'].toString().contains(".svg")
                          ? SvgPicture.asset(
                              bottomItems[index]['icon'],
                              color: selected == index
                                  ? CommonColor.primaryColor
                                  : Color(0xff808191),
                            )
                          : Image.asset(bottomItems[index]['icon'],
                              color: selected == index
                                  ? CommonColor.primaryColor
                                  : Color(0xff808191),
                              height: 17.sp,
                              width: 17.sp)
                      : bottomItemsWN[index]['icon'].toString().contains(".svg")
                          ? SvgPicture.asset(
                              bottomItemsWN[index]['icon'],
                              color: selected == index
                                  ? CommonColor.primaryColor
                                  : Color(0xff808191),
                            )
                          : Image.asset(bottomItemsWN[index]['icon'],
                              color: selected == index
                                  ? CommonColor.primaryColor
                                  : Color(0xff808191),
                              height: 17.sp,
                              width: 17.sp),
                  SizedBox(
                    height: 3.sp,
                  ),
                  Text(
                    GetStorageServices.getUserLoggedInStatus() == true
                        ? bottomItems[index]['label']
                        : bottomItemsWN[index]['label'],
                    style: TextStyle(
                      color:
                          selected == index ? Colors.black : Color(0xffA6A6A6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
