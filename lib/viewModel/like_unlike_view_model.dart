import 'package:finwizz/Models/repo/like_unlike_repo.dart';
import 'package:finwizz/Models/responseModel/like_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class LikeUnLikeViewModel extends GetxController {
  ApiResponse _likeUnlikeApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get likeUnlikeApiResponse => _likeUnlikeApiResponse;

  Future<void> likeUnLikeViewModel({Map<String, dynamic>? body}) async {
    _likeUnlikeApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      LikeResponseModel response = await LikeUnLikeRepo.likeRepo(body: body);
      print("LikeResponseModel==>$response");

      _likeUnlikeApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("LikeResponseModel==>$e");
      _likeUnlikeApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
