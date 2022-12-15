import 'package:finwizz/Models/responseModel/like_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class LikeUnLikeRepo extends BaseService {
  static Future<LikeResponseModel> likeRepo(
      {Map<String, dynamic>? body}) async {
    print('LINK response===>>>  ${APIConst.like}');

    var response = await APIService().getResponse(
        url: '${APIConst.like}', apitype: APIType.aPost, body: body);
    print('LikeResponseModel===>>>  $response');
    LikeResponseModel likeResponseModel = LikeResponseModel.fromJson(response);
    return likeResponseModel;
  }
}
