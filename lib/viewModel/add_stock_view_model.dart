import 'package:finwizz/Models/repo/add_stock_repo.dart';
import 'package:finwizz/Models/responseModel/add_stock_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class AddStockViewModel extends GetxController {
  ApiResponse _addStockApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get addStockApiResponse => _addStockApiResponse;

  Future<void> addStockViewModel({Map<String, dynamic>? body}) async {
    _addStockApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      AddStockResponseModel response =
          await AddStockRepo.addStockRepo(body: body);
      print("AddStockResponseModel==>$response");

      _addStockApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("AddStockResponseModel==>$e");
      _addStockApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
