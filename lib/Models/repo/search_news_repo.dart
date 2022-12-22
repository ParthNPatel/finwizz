import 'package:finwizz/Models/responseModel/search_news_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class SearchNewsRepo extends BaseService {
  static Future<SearchNewsResponseModel> searchNewsRepo(
      {String? companyId, String? searchText}) async {
    print('LINK response===>>>  ${APIConst.searchNews}');

    var response = await APIService().getResponse(
      url: '${APIConst.searchNews}$companyId' + "&text=$searchText",
      apitype: APIType.aGet,
    );
    print('SearchNewsResponseModel===>>>  $response');
    SearchNewsResponseModel searchNewsResponseModel =
        SearchNewsResponseModel.fromJson(response);
    return searchNewsResponseModel;
  }
}
