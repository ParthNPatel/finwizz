import 'dart:developer';

import 'package:finwizz/Models/responseModel/get_user_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class GetUserRepo extends BaseService {
  static Future<GetUserResponseModel> getUserRepo() async {
    log('LINK response===>>>  ${APIConst.user}');

    var response = await APIService()
        .getResponse(url: '${APIConst.user}', apitype: APIType.aGet);
    log('GetUserResponseModel===>>>  $response');
    GetUserResponseModel getUserResponseModel =
        GetUserResponseModel.fromJson(response);
    return getUserResponseModel;
  }
}
