import 'package:get/get.dart';

import '../Models/apis/api_response.dart';
import '../Models/repo/get_all_news_repo.dart';
import '../Models/responseModel/get_all_news_data.dart';

class GetAllNewsViewModel extends GetxController {
  ApiResponse _getNewsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getNewsApiResponse => _getNewsApiResponse;
  bool like = false;
  updateLike(bool val) {
    like = val;
    update();
  }

  bool isFavourite = false;
  updateFavourite(bool val) {
    isFavourite = val;
    update();
  }

  Future<void> getNewsViewModel(
      {bool isLoading = true, required String catId}) async {
    if (isLoading) {
      _getNewsApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      GetAllNewsModel response =
          await GetAllNewsRepo.getAllNewsRepo(catId: catId);
      print("GetNewsResponseModel==>$response");

      _getNewsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetNewsResponseModel==>$e==");
      _getNewsApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
