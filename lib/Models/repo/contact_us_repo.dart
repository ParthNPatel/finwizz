import 'package:finwizz/Models/responseModel/contact_us_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class ContactUsRepo extends BaseService {
  static Future<ContactUsResponseModel> contactUsRepo(
      {Map<String, dynamic>? body}) async {
    print('LINK response===>>>  ${APIConst.contact}');

    var response = await APIService().getResponse(
        url: '${APIConst.contact}', apitype: APIType.aPost, body: body);
    print('ContactUsResponseModel===>>>  $response');
    ContactUsResponseModel contactUsResponseModel =
        ContactUsResponseModel.fromJson(response);
    return contactUsResponseModel;
  }
}
