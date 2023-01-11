// To parse this JSON data, do
//
//     final latestMoversResponseModel = latestMoversResponseModelFromJson(jsonString);

import 'dart:convert';

LatestMoversResponseModel? latestMoversResponseModelFromJson(String str) =>
    LatestMoversResponseModel.fromJson(json.decode(str));

String latestMoversResponseModelToJson(LatestMoversResponseModel? data) =>
    json.encode(data!.toJson());

class LatestMoversResponseModel {
  LatestMoversResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  Data? data;

  factory LatestMoversResponseModel.fromJson(Map<String, dynamic> json) =>
      LatestMoversResponseModel(
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
    this.docs,
    this.total,
    this.limit,
    this.page,
    this.pages,
  });

  List<Doc?>? docs;
  int? total;
  int? limit;
  int? page;
  int? pages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        docs: json["docs"] == null
            ? []
            : List<Doc?>.from(json["docs"]!.map((x) => Doc.fromJson(x))),
        total: json["total"],
        limit: json["limit"],
        page: json["page"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? []
            : List<dynamic>.from(docs!.map((x) => x!.toJson())),
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
    this.percentage,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? title;
  String? description;
  int? percentage;
  String? startDate;
  String? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        percentage: json["percentage"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "percentage": percentage,
        "startDate": startDate,
        "endDate": endDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
