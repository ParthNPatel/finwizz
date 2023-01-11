import 'dart:developer';

import 'package:finwizz/Models/repo/latest_mopvers_repo.dart';
import 'package:finwizz/Models/responseModel/latest_movers_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class LatestMoversViewModel extends GetxController {
  ApiResponse _getLatestMoverssApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getLatestMoverssApiResponse => _getLatestMoverssApiResponse;

  Future<void> getLatestMoversViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _getLatestMoverssApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      LatestMoversResponseModel response =
          await LatestMoversRepo.latestMoversRepo();
      log("GetLatestMoverssResponseModel==>$response");

      _getLatestMoverssApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log("GetLatestMoverssResponseModel==>$e");
      _getLatestMoverssApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
