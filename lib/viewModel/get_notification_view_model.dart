import 'package:finwizz/Models/repo/get_notification_repo.dart';
import 'package:finwizz/Models/responseModel/get_ntification_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class GetNotificationViewModel extends GetxController {
  ApiResponse _getNotificationApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getNotificationApiResponse => _getNotificationApiResponse;

  Future<void> getNotificationViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _getNotificationApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      GetNotificationResponseModel response =
          await GetNotificationRepo.getNotificationRepo();
      print("GetNotificationResponseModel==>$response");

      _getNotificationApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetNotificationResponseModel==>$e==");
      _getNotificationApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
