import 'package:finwizz/Models/responseModel/insider_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class InsiderRepo extends BaseService {
  static Future<InsiderResponseModel> insiderRepo() async {
    print('LINK response===>>>  ${APIConst.insider}');

    var response = await APIService().getResponse(
      url: '${APIConst.insider}',
      apitype: APIType.aGet,
    );
    print('InsiderResponse===>>>  $response');
    InsiderResponseModel insidersResponseModel =
        InsiderResponseModel.fromJson(response);
    return insidersResponseModel;
  }
}
