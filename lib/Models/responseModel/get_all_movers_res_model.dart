// To parse this JSON data, do
//
//     final getAllMoversResponseModel = getAllMoversResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllMoversResponseModel? getAllMoversResponseModelFromJson(String str) =>
    GetAllMoversResponseModel.fromJson(json.decode(str));

String getAllMoversResponseModelToJson(GetAllMoversResponseModel? data) =>
    json.encode(data!.toJson());

class GetAllMoversResponseModel {
  GetAllMoversResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  List<Datum?>? data;

  factory GetAllMoversResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllMoversResponseModel(
        flag: json["flag"],
        data: json["data"] == null
            ? []
            : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.companyId,
    this.percentage,
    this.startDate,
    this.endDate,
    this.startPrice,
    this.currentPrice,
    this.type,
    this.likes,
    this.imageType,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
  });

  String? id;
  CompanyId? companyId;
  int? percentage;
  String? startDate;
  String? endDate;
  int? startPrice;
  int? currentPrice;
  int? type;
  int? likes;
  int? imageType;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isLiked;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        companyId: CompanyId.fromJson(json["companyId"]),
        percentage: json["percentage"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        startPrice: json["startPrice"],
        currentPrice: json["currentPrice"],
        type: json["type"],
        likes: json["likes"],
        imageType: json["imageType"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isLiked: json["isLiked"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "companyId": companyId!.toJson(),
        "percentage": percentage,
        "startDate": startDate,
        "endDate": endDate,
        "startPrice": startPrice,
        "currentPrice": currentPrice,
        "type": type,
        "likes": likes,
        "imageType": imageType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "isLiked": isLiked,
      };
}

class CompanyId {
  CompanyId({
    this.id,
    this.name,
    this.shortName,
    this.createdAt,
    this.updatedAt,
    this.companyIdId,
  });

  String? id;
  String? name;
  String? shortName;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? companyIdId;

  factory CompanyId.fromJson(Map<String, dynamic> json) => CompanyId(
        id: json["_id"],
        name: json["name"],
        shortName: json["shortName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        companyIdId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "shortName": shortName,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "id": companyIdId,
      };
}
