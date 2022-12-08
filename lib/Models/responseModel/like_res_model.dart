// To parse this JSON data, do
//
//     final likeResponseModel = likeResponseModelFromJson(jsonString);

import 'dart:convert';

LikeResponseModel likeResponseModelFromJson(String str) =>
    LikeResponseModel.fromJson(json.decode(str));

String likeResponseModelToJson(LikeResponseModel data) =>
    json.encode(data.toJson());

class LikeResponseModel {
  LikeResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  dynamic? data;

  factory LikeResponseModel.fromJson(Map<String, dynamic> json) =>
      LikeResponseModel(
        flag: json["flag"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data,
      };
}
