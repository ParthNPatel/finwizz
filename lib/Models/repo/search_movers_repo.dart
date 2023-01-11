import 'package:finwizz/Models/responseModel/search_movers_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class SearchMoversRepo extends BaseService {
  static Future<SearchMoversResponseModel> searchMoversRepo(
      {String? companyId, String? searchText}) async {
    print('LINK response===>>>  ${APIConst.searchMovers}');

    var response = await APIService().getResponse(
      url: '${APIConst.searchMovers}$searchText',
      apitype: APIType.aGet,
    );
    print('SearchMoversResponseModel===>>>  $response');
    SearchMoversResponseModel searchMoversResponseModel =
        SearchMoversResponseModel.fromJson(response);
    return searchMoversResponseModel;
  }
}
