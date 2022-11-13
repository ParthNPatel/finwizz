import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/view/Home/home_screen.dart';
import 'package:finwizz/view/OnBoarding/on_boarding.dart';
import 'package:finwizz/view/portfolio/portfolio_screen.dart';
import 'package:finwizz/view/portfolio/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'controllers/portfolio_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        title: 'FinWizz', initialBinding: BaseBindings(),
        debugShowCheckedModeBanner: false,
        // home: SearchScreen(),
        home: BottomNavScreen(selectedIndex: 0),
        // home: HomeScreen(),
      ),
    );
  }
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortFolioController(), fenix: true);
  }
}
