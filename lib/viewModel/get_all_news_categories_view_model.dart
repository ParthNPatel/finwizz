import 'package:finwizz/Models/repo/get_all_news_categories_repo.dart';
import 'package:finwizz/Models/responseModel/get_all_news_categories_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class GetAllNewsCategoriesViewModel extends GetxController {
  int newsIndicator = 10;

  newsFilter(int value) {
    if (value == 0) {
      newsIndicator = 10;
    } else if (value == 1) {
      newsIndicator = 1;
    } else if (value == 2) {
      newsIndicator = -1;
    } else {
      newsIndicator = 0;
    }
    update();
  }

  ApiResponse _getNewsCategoriesApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getNewsCategoriesApiResponse => _getNewsCategoriesApiResponse;

  Future<void> getNewsCategoriesViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _getNewsCategoriesApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      GetAllNewsCategoriesResponseModel response =
          await GetAllNewsCategoriesRepo.getAllNewsCategoriesRepo();
      print("GetNewsCategoriesResponseModel==>$response");

      _getNewsCategoriesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetNewsCategoriesResponseModel==>$e");
      _getNewsCategoriesApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
