// To parse this JSON data, do
//
//     final favouriteResponseModel = favouriteResponseModelFromJson(jsonString);

import 'dart:convert';

FavouriteResponseModel favouriteResponseModelFromJson(String str) =>
    FavouriteResponseModel.fromJson(json.decode(str));

String favouriteResponseModelToJson(FavouriteResponseModel data) =>
    json.encode(data.toJson());

class FavouriteResponseModel {
  FavouriteResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  String? data;

  factory FavouriteResponseModel.fromJson(Map<String, dynamic> json) =>
      FavouriteResponseModel(
        flag: json["flag"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data,
      };
}
