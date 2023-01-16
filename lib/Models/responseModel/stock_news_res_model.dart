// To parse this JSON data, do
//
//     final stockNewsResponseModel = stockNewsResponseModelFromJson(jsonString);

import 'dart:convert';

StockNewsResponseModel? stockNewsResponseModelFromJson(String str) =>
    StockNewsResponseModel.fromJson(json.decode(str));

String stockNewsResponseModelToJson(StockNewsResponseModel? data) =>
    json.encode(data!.toJson());

class StockNewsResponseModel {
  StockNewsResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  List<Datum?>? data;

  factory StockNewsResponseModel.fromJson(Map<String, dynamic> json) =>
      StockNewsResponseModel(
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
    this.title,
    this.description,
    this.categoryId,
    this.companyId,
    this.type,
    this.likes,
    this.generic,
    this.createdAt,
    this.updatedAt,
    this.source,
    this.isLiked,
    this.isFavourite,
  });

  String? id;
  String? title;
  String? description;
  CategoryId? categoryId;
  CompanyId? companyId;
  int? type;
  int? likes;
  bool? generic;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? source;
  bool? isLiked;
  bool? isFavourite;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        categoryId: CategoryId.fromJson(json["categoryId"]),
        companyId: CompanyId.fromJson(json["companyId"]),
        type: json["type"],
        likes: json["likes"],
        generic: json["generic"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        source: json["source"],
        isLiked: json["isLiked"],
        isFavourite: json["isFavourite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "categoryId": categoryId!.toJson(),
        "companyId": companyId!.toJson(),
        "type": type,
        "likes": likes,
        "generic": generic,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "source": source,
        "isLiked": isLiked,
        "isFavourite": isFavourite,
      };
}

class CategoryId {
  CategoryId({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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
