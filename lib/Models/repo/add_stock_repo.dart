import 'package:finwizz/Models/responseModel/add_stock_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class AddStockRepo extends BaseService {
  static Future<AddStockResponseModel> addStockRepo(
      {Map<String, dynamic>? body}) async {
    print('LINK response===>>>  ${APIConst.addStock}');

    var response = await APIService().getResponse(
        url: '${APIConst.addStock}', apitype: APIType.aPost, body: body);
    print('AddStockResponseModel===>>>  $response');
    AddStockResponseModel addStockResponseModel =
        AddStockResponseModel.fromJson(response);
    return addStockResponseModel;
  }
}
