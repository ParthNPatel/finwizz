import 'package:finwizz/Models/repo/stock_remove_repo.dart';
import 'package:finwizz/Models/responseModel/stock_remove_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class RemoveStockViewModel extends GetxController {
  ApiResponse _removeStockApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get removeStockApiResponse => _removeStockApiResponse;

  Future<void> removeStockViewModel({Map<String, dynamic>? body}) async {
    _removeStockApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      StockRemoveResponseModel response =
          await RemoveStockRepo.removeStockRepo(body: body);
      print("StockRemoveResponseModel==>$response");

      _removeStockApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("StockRemoveResponseModel==>$e");
      _removeStockApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
