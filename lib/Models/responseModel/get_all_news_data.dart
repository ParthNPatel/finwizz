// To parse this JSON data, do
//
//     final getAllNewsModel = getAllNewsModelFromJson(jsonString);

import 'dart:convert';

GetAllNewsModel getAllNewsModelFromJson(String str) =>
    GetAllNewsModel.fromJson(json.decode(str));

String getAllNewsModelToJson(GetAllNewsModel data) =>
    json.encode(data.toJson());

class GetAllNewsModel {
  GetAllNewsModel({
    this.flag,
    this.data,
  });

  bool? flag;
  List<News>? data;

  factory GetAllNewsModel.fromJson(Map<String, dynamic> json) =>
      GetAllNewsModel(
        flag: json["flag"],
        data: List<News>.from(json["data"].map((x) => News.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class News {
  News({
    this.id,
    this.title,
    this.description,
    this.categoryId,
    this.companyId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.likes,
    this.isLiked,
    this.isFavourite,
  });

  String? id;
  String? title;
  String? description;
  YId? categoryId;
  YId? companyId;
  int? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likes;
  bool? isLiked;
  bool? isFavourite;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        categoryId: json["categoryId"] == null
            ? null
            : YId.fromJson(json["categoryId"]),
        companyId:
            json["companyId"] == null ? null : YId.fromJson(json["companyId"]),
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        likes: json["likes"] == null ? null : json["likes"],
        isLiked: json["isLiked"],
        isFavourite: json["isFavourite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "categoryId": categoryId == null ? null : categoryId!.toJson(),
        "companyId": companyId == null ? null : companyId!.toJson(),
        "type": type,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "likes": likes == null ? null : likes,
        "isLiked": isLiked,
        "isFavourite": isFavourite,
      };
}

class YId {
  YId({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory YId.fromJson(Map<String, dynamic> json) => YId(
        id: json["_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
