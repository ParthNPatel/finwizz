// To parse this JSON data, do
//
//     final addStockResponseModel = addStockResponseModelFromJson(jsonString);

import 'dart:convert';

AddStockResponseModel addStockResponseModelFromJson(String str) =>
    AddStockResponseModel.fromJson(json.decode(str));

String addStockResponseModelToJson(AddStockResponseModel data) =>
    json.encode(data.toJson());

class AddStockResponseModel {
  AddStockResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  String? data;

  factory AddStockResponseModel.fromJson(Map<String, dynamic> json) =>
      AddStockResponseModel(
        flag: json["flag"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data,
      };
}
