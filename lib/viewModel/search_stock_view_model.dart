import 'package:finwizz/Models/repo/search_stock_repo.dart';
import 'package:finwizz/Models/responseModel/search_stock_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class SearchStockViewModel extends GetxController {
  List addStockList = [];

  addStock(String id) {
    if (addStockList.contains(id)) {
      addStockList.remove(id);
    } else {
      addStockList.add(id);
    }
    update();
  }

  ApiResponse _searchStockApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get searchStockApiResponse => _searchStockApiResponse;

  Future<void> searchStockViewModel(
      {String searchText = '', bool isLoading = true}) async {
    if (isLoading) {
      _searchStockApiResponse = ApiResponse.loading(message: 'Loading');
    }

    update();
    try {
      SearchStockResponseModel response =
          await SearchStockRepo.searchStockRepo(searchText: searchText);
      print("SearchStockResponseModel==>$response");

      _searchStockApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("SearchStockResponseModel==>$e");
      _searchStockApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
