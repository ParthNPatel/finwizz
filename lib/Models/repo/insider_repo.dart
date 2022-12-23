import 'package:finwizz/Models/responseModel/insider_res_model.dart';
import 'package:finwizz/Models/responseModel/single_insider_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class InsiderRepo extends BaseService {
  static Future<dynamic> insiderRepo() async {
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

  static Future<dynamic> singleInsiderRepo({String? companyId}) async {
    print('LINK response===>>>  ${APIConst.insider}');

    var response = await APIService().getResponse(
      url: '${APIConst.insider}/' + companyId!,
      apitype: APIType.aGet,
    );

    print('Single InsiderResponse===>>>  $response');

    SingleInsiderResponseModel singleInsiderResponseModel =
        SingleInsiderResponseModel.fromJson(response);
    return singleInsiderResponseModel;
  }
}
