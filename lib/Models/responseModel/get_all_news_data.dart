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
  List<Datum>? data;

  factory GetAllNewsModel.fromJson(Map<String, dynamic> json) =>
      GetAllNewsModel(
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
    this.title,
    this.description,
    this.categoryId,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.isFavourite,
  });

  String? id;
  String? title;
  String? description;
  dynamic categoryId;
  dynamic companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isLiked;
  bool? isFavourite;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        categoryId: json["categoryId"],
        companyId: json["companyId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isLiked: json["isLiked"],
        isFavourite: json["isFavourite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "categoryId": categoryId,
        "companyId": companyId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "isLiked": isLiked,
        "isFavourite": isFavourite,
      };
}
