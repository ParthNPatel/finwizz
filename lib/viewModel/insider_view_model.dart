import 'package:finwizz/Models/repo/insider_repo.dart';
import 'package:finwizz/Models/responseModel/insider_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class InsiderViewModel extends GetxController {
  ApiResponse _getInsidersApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getInsidersApiResponse => _getInsidersApiResponse;

  Future<void> getInsiderViewModel({bool isLoading = true}) async {
    if (isLoading) {
      _getInsidersApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      InsiderResponseModel response = await InsiderRepo.insiderRepo();
      print("GetInsidersResponseModel==>$response");

      _getInsidersApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetInsidersResponseModel==>$e");
      _getInsidersApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  ApiResponse _getSingleInsidersApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getSingleInsidersApiResponse => _getSingleInsidersApiResponse;

  Future<void> getSingleInsiderViewModel(
      {bool isLoading = true, String? companyId}) async {
    if (isLoading) {
      _getSingleInsidersApiResponse = ApiResponse.loading(message: 'Loading');
    }

    // update();
    try {
      InsiderResponseModel response =
          await InsiderRepo.singleInsiderRepo(companyId: companyId!);
      print("GetSingleInsidersResponseModel==>$response");

      _getSingleInsidersApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("GetSingleInsidersResponseModel==>$e");
      _getSingleInsidersApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
