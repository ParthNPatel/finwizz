// To parse this JSON data, do
//
//     final searchStockResponseModel = searchStockResponseModelFromJson(jsonString);

import 'dart:convert';

SearchStockResponseModel searchStockResponseModelFromJson(String str) =>
    SearchStockResponseModel.fromJson(json.decode(str));

String searchStockResponseModelToJson(SearchStockResponseModel data) =>
    json.encode(data.toJson());

class SearchStockResponseModel {
  SearchStockResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  List<Datum>? data;

  factory SearchStockResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchStockResponseModel(
        flag: json["flag"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
