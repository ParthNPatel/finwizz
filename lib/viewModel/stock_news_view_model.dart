import 'package:finwizz/Models/repo/stock_news_repo.dart';
import 'package:finwizz/Models/responseModel/stock_news_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class StockNewsViewModel extends GetxController {
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

  ApiResponse _stockNewsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get stockNewsApiResponse => _stockNewsApiResponse;

  Future<void> stockNewsViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _stockNewsApiResponse = ApiResponse.loading(message: 'Loading');
    }

    update();
    try {
      StockNewsResponseModel response = await StockNewsRepo.stockNewsRepo();
      print("StockNewsResponseModel==>$response");

      _stockNewsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("StockNewsResponseModel==>$e");
      _stockNewsApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
