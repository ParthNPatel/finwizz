import 'package:finwizz/Models/responseModel/get_all_news_categories_res_model.dart';

import '../../constant/api_const.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class GetAllNewsCategoriesRepo extends BaseService {
  static Future<GetAllNewsCategoriesResponseModel>
      getAllNewsCategoriesRepo() async {
    print('LINK response===>>>  ${APIConst.getAllNewsCategories}');

    var response = await APIService().getResponse(
        url: '${APIConst.getAllNewsCategories}', apitype: APIType.aGet);
    print('GetAllNewsResponse===>>>  $response');
    GetAllNewsCategoriesResponseModel getAllNewsCategoriesResponseModel =
        GetAllNewsCategoriesResponseModel.fromJson(response);
    return getAllNewsCategoriesResponseModel;
  }
}
