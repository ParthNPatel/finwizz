import 'package:finwizz/Models/responseModel/stock_news_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class StockNewsRepo extends BaseService {
  static Future<StockNewsResponseModel> stockNewsRepo() async {
    print('LINK response===>>>  ${APIConst.summaryStocks}');

    var response = await APIService().getResponse(
      url: '${APIConst.summaryStocks}',
      apitype: APIType.aGet,
    );
    print('StockNewsResponseModel===>>>  $response');
    StockNewsResponseModel stockNewsResponseModel =
        StockNewsResponseModel.fromJson(response);
    return stockNewsResponseModel;
  }
}
