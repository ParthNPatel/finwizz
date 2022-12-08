import 'package:get/get.dart';
import '../Models/apis/api_response.dart';
import '../Models/repo/get_all_news_repo.dart';
import '../Models/responseModel/get_all_news_data.dart';

class GetAllNewsViewModel extends GetxController {
  ApiResponse _getNewsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getCommentApiResponse => _getNewsApiResponse;

  Future<void> getCommentViewModel() async {
    _getNewsApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      GetAllNewsModel response = await GetAllNewsRepo.getAllNewsRepo();
      print("GetNewsResponseModel==>$response");

      _getNewsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetNewsResponseModel==>$e");
      _getNewsApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
