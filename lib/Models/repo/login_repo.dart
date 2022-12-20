import 'dart:developer';

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
      log("model === > $model");
      progress.show();
      var response = await APIService().getResponse(
          url: APIConst.loginUrl, apitype: APIType.aPost, body: model);
      log('Login response===>>>  $response');
      log('${response['flag']}');
      log('${response['data']['token']}');
      if (response['flag'] == true) {
        GetStorageServices.setBarrierToken('${response['token']}');
        GetStorageServices.setNewsAlerts(response['data']['newsAlerts']);
        GetStorageServices.setPortfolioAlerts(
            response['data']['portfolioAlerts']);
        Get.offAll(
          BottomNavScreen(),
        );
      } else {
        progress.dismiss();

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
