import 'package:finwizz/Models/responseModel/favourite_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class FavUnFavRepo extends BaseService {
  static Future<FavouriteResponseModel> favUnFavRepo(
      {Map<String, dynamic>? body}) async {
    print('LINK response===>>>  ${APIConst.like}');

    var response = await APIService().getResponse(
        url: '${APIConst.favourite}', apitype: APIType.aPost, body: body);
    print('favouriteResponseModel===>>>  $response');
    FavouriteResponseModel favouriteResponseModel =
        FavouriteResponseModel.fromJson(response);
    return favouriteResponseModel;
  }
}
