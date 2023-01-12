import 'package:finwizz/Models/repo/search_news_repo.dart';
import 'package:finwizz/Models/responseModel/search_news_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class SearchNewsViewModel extends GetxController {
  List addNewsList = [];

  addNews(String id) {
    if (addNewsList.contains(id)) {
      addNewsList.remove(id);
    } else {
      addNewsList.add(id);
    }
    update();
  }

  ApiResponse _searchNewsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get searchNewsApiResponse => _searchNewsApiResponse;

  Future<void> searchNewsViewModel(
      {String searchText = '',
      String companyId = '',
      bool isLoading = true}) async {
    if (isLoading) {
      _searchNewsApiResponse = ApiResponse.loading(message: 'Loading');
    }

    update();
    try {
      SearchNewsResponseModel response = await SearchNewsRepo.searchNewsRepo(
          companyId: companyId, searchText: searchText);
      print("SearchNewsResponseModel==>$response");

      _searchNewsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("SearchNewsResponseModel== eee >$e");
      _searchNewsApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
