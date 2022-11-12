import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/view/Home/home_screen.dart';
import 'package:finwizz/view/OnBoarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

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
        title: 'FinWizz',
        debugShowCheckedModeBanner: false,
        home: BottomNavScreen(),
        // home: HomeScreen(),
      ),
    );
  }
}
