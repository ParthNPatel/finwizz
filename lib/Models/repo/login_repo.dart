import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/common_widget.dart';
import '../../constant/api_const.dart';
import '../../get_storage_services/get_storage_service.dart';
import '../../view/BottomNav/bottom_nav_screen.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class LoginRepo extends BaseService {
  static Future loginUserRepo(
      {required Map<String, dynamic> model,
      required final progress,
      bool isNavigator = false}) async {
    try {
      progress.show();
      var response = await APIService().getResponse(
          url: APIConst.loginUrl, apitype: APIType.aPost, body: model);
      print('Login response===>>>  $response');
      print('${response['flag']}');
      print('${response['data']['token']}');
      if (response['flag'] == true) {
        GetStorageServices.setBarrierToken('${response['token']}');
        Get.offAll(
          BottomNavScreen(),
        );
      } else {
        CommonWidget.getSnackBar(
          message: 'Ops!',
          title: 'Login Failed',
          duration: 2,
          color: Colors.red,
        );
      }
    } catch (e) {
      CommonWidget.getSnackBar(
        message: 'Ops!',
        title: 'Failed',
        duration: 2,
        color: Colors.red,
      );
    }
  }
}
