// To parse this JSON data, do
//
//     final searchNewsResponseModel = searchNewsResponseModelFromJson(jsonString);

import 'dart:convert';

SearchNewsResponseModel searchNewsResponseModelFromJson(String str) =>
    SearchNewsResponseModel.fromJson(json.decode(str));

String searchNewsResponseModelToJson(SearchNewsResponseModel data) =>
    json.encode(data.toJson());

class SearchNewsResponseModel {
  SearchNewsResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  SearchData? data;

  factory SearchNewsResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchNewsResponseModel(
        flag: json["flag"],
        data: SearchData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": data!.toJson(),
      };
}

class SearchData {
  SearchData({
    this.docs,
    this.total,
    this.limit,
    this.page,
    this.pages,
  });

  List<Doc>? docs;
  int? total;
  int? limit;
  int? page;
  int? pages;

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        total: json["total"],
        limit: json["limit"],
        page: json["page"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
        "total": total,
        "limit": limit,
        "page": page,
        "pages": pages,
      };
}

class Doc {
  Doc({
    this.id,
    this.title,
    this.description,
    this.categoryId,
    this.companyId,
    this.type,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.likes,
    this.isLiked,
    this.isFavourite,
  });

  String? id;
  String? title;
  String? description;
  String? categoryId;
  String? companyId;
  int? type;
  String? source;

  DateTime? createdAt;
  DateTime? updatedAt;
  int? likes;
  bool? isLiked;
  bool? isFavourite;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        categoryId: json["categoryId"],
        companyId: json["companyId"],
        type: json["type"],
        source: json["source"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        likes: json["likes"],
        isLiked: json["isLiked"],
        isFavourite: json["isFavourite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "categoryId": categoryId,
        "companyId": companyId,
        "type": type,
        "source": source,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "likes": likes,
        "isLiked": isLiked,
        "isFavourite": isFavourite,
      };
}
