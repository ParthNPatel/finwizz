// To parse this JSON data, do
//
//     final moversLikeUnlikeModel = moversLikeUnlikeModelFromJson(jsonString);

import 'dart:convert';

MoversLikeUnlikeModel? moversLikeUnlikeModelFromJson(String str) =>
    MoversLikeUnlikeModel.fromJson(json.decode(str));

String moversLikeUnlikeModelToJson(MoversLikeUnlikeModel? data) =>
    json.encode(data!.toJson());

class MoversLikeUnlikeModel {
  MoversLikeUnlikeModel({
    this.flag,
    this.data,
  });

  bool? flag;
  Data? data;

  factory MoversLikeUnlikeModel.fromJson(Map<String, dynamic> json) =>
      MoversLikeUnlikeModel(
        flag: json["flag"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.companyId,
    this.percentage,
    this.startDate,
    this.endDate,
    this.startPrice,
    this.currentPrice,
    this.type,
    this.likes,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? companyId;
  int? percentage;
  DateTime? startDate;
  DateTime? endDate;
  int? startPrice;
  int? currentPrice;
  int? type;
  int? likes;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        companyId: json["companyId"],
        percentage: json["percentage"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        startPrice: json["startPrice"],
        currentPrice: json["currentPrice"],
        type: json["type"],
        likes: json["likes"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "companyId": companyId,
        "percentage": percentage,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "startPrice": startPrice,
        "currentPrice": currentPrice,
        "type": type,
        "likes": likes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
