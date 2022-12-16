import 'dart:developer';

import 'package:finwizz/Models/repo/stock_summary_repo.dart';
import 'package:finwizz/Models/responseModel/stock_summary_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class StockSummaryViewModel extends GetxController {
  ApiResponse _stockSummaryApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get stockSummaryApiResponse => _stockSummaryApiResponse;

  Future<void> stockSummaryViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _stockSummaryApiResponse = ApiResponse.loading(message: 'Loading');
    }

    try {
      StockSummaryResponseModel response =
          await StockSummaryRepo.stockSummaryRepo();
      log("StockSummaryResponseModel==>$response");

      _stockSummaryApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log("StockSummaryResponseModel==> erur $e");
      _stockSummaryApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
