import 'dart:developer';

import 'package:finwizz/Models/responseModel/movers_like_unlike_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class MoversLikeUnLikeRepo extends BaseService {
  static Future<MoversLikeUnlikeModel> moversLikeUnlikeRepo(
      {Map<String, dynamic>? body}) async {
    log('LINK response===>>>  ${APIConst.moversLike}');

    var response = await APIService().getResponse(
        url: '${APIConst.moversLike}', apitype: APIType.aPost, body: body);
    log('LikeResponseModel===>>>  $response');
    MoversLikeUnlikeModel moversLikeUnlikeModel =
        MoversLikeUnlikeModel.fromJson(response);
    return moversLikeUnlikeModel;
  }
}
