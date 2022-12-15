import 'package:finwizz/Models/responseModel/search_stock_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class SearchStockRepo extends BaseService {
  static Future<SearchStockResponseModel> searchStockRepo(
      {String? searchText}) async {
    print('LINK response===>>>  ${APIConst.searchStock}');

    var response = await APIService().getResponse(
      url: '${APIConst.searchStock}$searchText',
      apitype: APIType.aGet,
    );
    print('SearchStockResponseModel===>>>  $response');
    SearchStockResponseModel searchStockResponseModel =
        SearchStockResponseModel.fromJson(response);
    return searchStockResponseModel;
  }
}
