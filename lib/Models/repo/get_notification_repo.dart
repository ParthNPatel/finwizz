import 'package:finwizz/Models/responseModel/get_ntification_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class GetNotificationRepo extends BaseService {
  static Future<GetNotificationResponseModel> getNotificationRepo() async {
    print('LINK response===>>>  ${APIConst.notification}');

    var response = await APIService().getResponse(
      url: '${APIConst.notification}',
      apitype: APIType.aGet,
    );
    print('GetNotificationResponse===>>>  $response');
    GetNotificationResponseModel getNotificationModel =
        GetNotificationResponseModel.fromJson(response);
    return getNotificationModel;
  }
}
