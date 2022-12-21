import 'package:finwizz/Models/repo/get_user_repo.dart';
import 'package:finwizz/Models/responseModel/get_user_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class GetUserViewModel extends GetxController {
  ApiResponse _getUserApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getUserApiResponse => _getUserApiResponse;

  Future<void> getUserViewModel({bool isLoading = false}) async {
    if (isLoading) {
      _getUserApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      GetUserResponseModel response = await GetUserRepo.getUserRepo();
      print("getUserResponseModel==>$response");

      _getUserApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("getUserResponseModel==>$e");
      _getUserApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
