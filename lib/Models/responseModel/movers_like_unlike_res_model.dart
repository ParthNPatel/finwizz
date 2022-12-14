// To parse this JSON data, do
//
//     final moversLikeUnlikeModel = moversLikeUnlikeModelFromJson(jsonString);

import 'dart:convert';

MoversLikeUnlikeModel moversLikeUnlikeModelFromJson(String str) =>
    MoversLikeUnlikeModel.fromJson(json.decode(str));

String moversLikeUnlikeModelToJson(MoversLikeUnlikeModel data) =>
    json.encode(data.toJson());

class MoversLikeUnlikeModel {
  MoversLikeUnlikeModel({
    this.flag,
    this.data,
  });

  bool? flag;
  dynamic data;

  factory MoversLikeUnlikeModel.fromJson(Map<String, dynamic> json) =>
      MoversLikeUnlikeModel(
        flag: json["flag"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data,
      };
}
