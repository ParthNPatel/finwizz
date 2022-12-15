import '../../constant/api_const.dart';
import '../responseModel/get_all_news_data.dart';
import '../services/api_services.dart';
import '../services/base_service.dart';

class GetAllNewsRepo extends BaseService {
  static Future<GetAllNewsModel> getAllNewsRepo({String? catId}) async {
    print('LINK response===>>>  ${APIConst.getAllNews}');

    var response = await APIService().getResponse(
      url: '${APIConst.getAllNews}' + '?categoryId=${catId}',
      apitype: APIType.aGet,
    );
    print('GetAllNewsResponse===>>>  $response');
    GetAllNewsModel getAllNewsModel = GetAllNewsModel.fromJson(response);
    return getAllNewsModel;
  }
}
