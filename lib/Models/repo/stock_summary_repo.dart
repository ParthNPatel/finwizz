import 'package:finwizz/Models/responseModel/stock_summary_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class StockSummaryRepo extends BaseService {
  static Future<StockSummaryResponseModel> stockSummaryRepo() async {
    print('LINK response===>>>  ${APIConst.stockSummary}');

    var response = await APIService().getResponse(
      url: '${APIConst.stockSummary}',
      apitype: APIType.aGet,
    );
    print('StockSummaryResponseModel===>>>  $response');
    StockSummaryResponseModel stockSummaryResponseModel =
        StockSummaryResponseModel.fromJson(response);
    return stockSummaryResponseModel;
  }
}
