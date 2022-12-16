import 'package:finwizz/Models/repo/update_user_repo.dart';
import 'package:finwizz/Models/responseModel/update_user_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class UpdateUserViewModel extends GetxController {
  ApiResponse _updateUserApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get updateUserApiResponse => _updateUserApiResponse;

  Future<void> updateUserViewModel({Map<String, dynamic>? body}) async {
    _updateUserApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      UpdateUserResponseModel response =
          await UpdateUserRepo.updateUserRepo(body: body);
      print("UpdateUserResponseModel==>$response");

      _updateUserApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("UpdateUserResponseModel==>erur $e");
      _updateUserApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
