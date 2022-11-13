import 'package:finwizz/view/BookMark/book_mark_screen.dart';
import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/view/Home/home_screen.dart';
import 'package:finwizz/view/OnBoarding/on_boarding.dart';
import 'package:finwizz/view/SignUp_SignIn/sign_in_screen.dart';
import 'package:finwizz/view/SignUp_SignIn/sign_up_screen.dart';
import 'package:finwizz/view/portfolio/portfolio_screen.dart';
import 'package:finwizz/view/portfolio/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'controller/handle_screen_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent),
  );

  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        initialBinding: BaseBindings(),
        title: 'FinWizz',
        debugShowCheckedModeBanner: false,
        home: BottomNavScreen(),
        // home: HomeScreen(),
      ),
    );
  }
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HandleScreenController(), fenix: true);
  }
}
