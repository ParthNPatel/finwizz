import 'package:finwizz/Models/responseModel/stock_remove_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class RemoveStockRepo extends BaseService {
  static Future<StockRemoveResponseModel> removeStockRepo(
      {Map<String, dynamic>? body}) async {
    print('LINK response===>>>  ${APIConst.removeStock}');

    var response = await APIService().getResponse(
        url: '${APIConst.removeStock}', apitype: APIType.aPost, body: body);
    print('StockRemoveResponseModel===>>>  $response');
    StockRemoveResponseModel stockRemoveResponseModel =
        StockRemoveResponseModel.fromJson(response);
    return stockRemoveResponseModel;
  }
}
