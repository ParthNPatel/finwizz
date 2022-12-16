import 'dart:developer';

import 'package:finwizz/Models/responseModel/update_user_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class UpdateUserRepo extends BaseService {
  static Future<UpdateUserResponseModel> updateUserRepo(
      {Map<String, dynamic>? body}) async {
    log('LINK response===>>>  ${APIConst.user}');
    log('LINK body===>>>  ${body}');

    var response = await APIService().getPatchResponse(
        url: '${APIConst.user}', apitype: APIType.aPatch, body1: body);
    log('UpdateUserResponseModel===>>>  $response');
    UpdateUserResponseModel updateUserResponseModel =
        UpdateUserResponseModel.fromJson(response);
    return updateUserResponseModel;
  }
}
