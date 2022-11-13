import 'package:get/get.dart';

class PortFolioController extends GetxController {
  bool isAddShare = false;
  bool _isDelete = false;

  bool get isDelete => _isDelete;

  set isDelete(bool value) {
    _isDelete = value;
    update();
  }

  List listOfDeletePortFolio = [];
  setListOfPortFolio({required String shareName}) {
    if (listOfDeletePortFolio.contains(shareName)) {
      listOfDeletePortFolio.remove(shareName);
    } else {
      listOfDeletePortFolio.add(shareName);
    }
    update();
  }
}
