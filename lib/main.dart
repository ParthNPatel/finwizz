import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/view/OnBoarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'controller/handle_screen_controller.dart';
import 'controllers/portfolio_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent),
  );

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        initialBinding: BaseBindings(),
        title: 'FinWizz',
        debugShowCheckedModeBanner: false,
        //home: InsiderTabScreen(),
        home: GetStorageServices.getUserLoggedInStatus() == true
            ? BottomNavScreen(selectedIndex: 0)
            : OnBoardingScreen(),
        //home: MyHomePage(title: "Hii"),
      ),
    );
  }

  HandleScreenController handleScreenController =
      Get.put(HandleScreenController());
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HandleScreenController(), fenix: true);
    Get.lazyPut(() => PortFolioController(), fenix: true);
  }
}
