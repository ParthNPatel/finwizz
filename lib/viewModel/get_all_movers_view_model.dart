import 'dart:developer';

import 'package:finwizz/Models/repo/get_all_movers_repo.dart';
import 'package:finwizz/Models/responseModel/get_all_movers_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class GetAllMoverViewModel extends GetxController {
  ApiResponse _getMoversApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getMoversApiResponse => _getMoversApiResponse;
  // bool like = false;
  // updateLike(bool val) {
  //   like = val;
  //   update();
  // }
  //
  // bool isFavourite = false;
  // updateFavourite(bool val) {
  //   isFavourite = val;
  //   update();
  // }

  Future<void> getMoversViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _getMoversApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      GetAllMoversResponseModel response =
          await GetAllMoverRepo.getAllMoverRepo();
      log("GetMoversResponseModel==>$response");

      _getMoversApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log("GetMoversResponseModel==>$e");
      _getMoversApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
