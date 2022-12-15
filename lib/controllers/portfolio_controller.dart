import 'dart:developer';

import 'package:get/get.dart';

class PortFolioController extends GetxController {
  bool isAddShare = false;
  bool _isDelete = false;
  bool _isDeleteAvailable = false;

  bool get isDelete => _isDelete;
  bool get isDeleteAvailable => _isDeleteAvailable;

  set isDelete(bool value) {
    _isDelete = value;
    update();
  }

  set isDeleteAvailable(bool value) {
    _isDeleteAvailable = value;
    // update();
  }

  List listOfDeletePortFolio = [];
  setListOfPortFolio({required String shareName}) {
    if (listOfDeletePortFolio.contains(shareName)) {
      listOfDeletePortFolio.remove(shareName);
      log('SELECTED LIST :- ${listOfDeletePortFolio}');
    } else {
      listOfDeletePortFolio.add(shareName);
      log('SELECTE LIST :- ${listOfDeletePortFolio}');
    }
    update();
  }

  int _selected = 0;

  int get selected => _selected;

  set selected(int value) {
    _selected = value;
    update();
  }
  // int mmm=0;
  // setInt({int? value}){
  //   mmm=value;
  //   update();
  // };
}
