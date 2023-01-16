import 'dart:developer';

import 'package:finwizz/Models/repo/movers_like_unlike_repo.dart';
import 'package:finwizz/Models/responseModel/movers_like_unlike_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class MoversLikeUnLikeViewModel extends GetxController {
  ApiResponse _moversLikeUnLikeApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get moversLikeUnLikeApiResponse => _moversLikeUnLikeApiResponse;

  Future<void> moversLikeUnLikeViewModel({Map<String, dynamic>? body}) async {

    log("body ==== > ${body}");

    _moversLikeUnLikeApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      MoversLikeUnlikeModel response =
          await MoversLikeUnLikeRepo.moversLikeUnlikeRepo(body: body);
      log("MoversLikeUnlikeModel==>$response");

      _moversLikeUnLikeApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log("MoversLikeUnlikeModel==>$e");
      _moversLikeUnLikeApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
