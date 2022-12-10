// To parse this JSON data, do
//
//     final stockRemoveResponseModel = stockRemoveResponseModelFromJson(jsonString);

import 'dart:convert';

StockRemoveResponseModel stockRemoveResponseModelFromJson(String str) =>
    StockRemoveResponseModel.fromJson(json.decode(str));

String stockRemoveResponseModelToJson(StockRemoveResponseModel data) =>
    json.encode(data.toJson());

class StockRemoveResponseModel {
  StockRemoveResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  String? data;

  factory StockRemoveResponseModel.fromJson(Map<String, dynamic> json) =>
      StockRemoveResponseModel(
        flag: json["flag"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data,
      };
}
