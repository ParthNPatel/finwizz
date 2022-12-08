import 'package:finwizz/Models/repo/fav_unfav_repo.dart';
import 'package:finwizz/Models/responseModel/favourite_res_model.dart';
import 'package:get/get.dart';

import '../Models/apis/api_response.dart';

class FavUnFavViewModel extends GetxController {
  ApiResponse _favUnFavApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get favUnFavApiResponse => _favUnFavApiResponse;

  Future<void> favUnFavViewModel({Map<String, dynamic>? body}) async {
    _favUnFavApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      FavouriteResponseModel response =
          await FavUnFavRepo.favUnFavRepo(body: body);
      print("FavouriteResponseModel==>$response");

      _favUnFavApiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("FavouriteResponseModel==>$e");
      _favUnFavApiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
