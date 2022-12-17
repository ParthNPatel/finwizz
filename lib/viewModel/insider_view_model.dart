import 'package:finwizz/Models/repo/insider_repo.dart';
import 'package:finwizz/Models/responseModel/insider_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class InsiderViewModel extends GetxController {
  ApiResponse _getMoversApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getMoversApiResponse => _getMoversApiResponse;

  Future<void> getMoversViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _getMoversApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      InsiderResponseModel response = await InsiderRepo.insiderRepo();
      print("GetMoversResponseModel==>$response");

      _getMoversApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetMoversResponseModel==>$e");
      _getMoversApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
