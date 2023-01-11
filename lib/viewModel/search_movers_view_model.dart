import 'package:finwizz/Models/repo/search_movers_repo.dart';
import 'package:finwizz/Models/responseModel/search_movers_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class SearchMoversViewModel extends GetxController {
  List addMoversList = [];

  addMovers(String id) {
    if (addMoversList.contains(id)) {
      addMoversList.remove(id);
    } else {
      addMoversList.add(id);
    }
    update();
  }

  ApiResponse _searchMoversApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get searchMoversApiResponse => _searchMoversApiResponse;

  Future<void> searchMoversViewModel(
      {String searchText = '', bool isLoading = true}) async {
    if (isLoading) {
      _searchMoversApiResponse = ApiResponse.loading(message: 'Loading');
    }

    update();
    try {
      SearchMoversResponseModel response =
          await SearchMoversRepo.searchMoversRepo(searchText: searchText);
      print("SearchMoversResponseModel==>$response");

      _searchMoversApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("SearchMoversResponseModel==>$e");
      _searchMoversApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
