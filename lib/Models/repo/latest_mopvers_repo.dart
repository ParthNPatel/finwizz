import 'package:finwizz/Models/responseModel/latest_movers_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class LatestMoversRepo extends BaseService {
  static Future<LatestMoversResponseModel> latestMoversRepo(
      {String? companyId, String? latestText}) async {
    print('LINK response===>>>  ${APIConst.moversLatest}');

    var response = await APIService().getLatestMoversResponse(
      url: '${APIConst.moversLatest}',
      apitype: APIType.aGet,
    );
    print('LatestMoversResponseModel===>>>  $response');
    LatestMoversResponseModel latestMoversResponseModel =
        LatestMoversResponseModel.fromJson(response);
    return latestMoversResponseModel;
  }
}
