import 'package:finwizz/Models/responseModel/get_all_movers_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class GetAllMoverRepo extends BaseService {
  static Future<GetAllMoversResponseModel> getAllMoverRepo() async {
    print('LINK response===>>>  ${APIConst.movers}');

    var response = await APIService().getResponse(
      url: '${APIConst.movers}',
      apitype: APIType.aGet,
    );
    print('GetAllMoverResponse===>>>  $response');
    GetAllMoversResponseModel getAllMoversResponseModel =
        GetAllMoversResponseModel.fromJson(response);
    return getAllMoversResponseModel;
  }
}
