// To parse this JSON data, do
//
//     final searchMoversResponseModel = searchMoversResponseModelFromJson(jsonString);

import 'dart:convert';

SearchMoversResponseModel? searchMoversResponseModelFromJson(String str) =>
    SearchMoversResponseModel.fromJson(json.decode(str));

String searchMoversResponseModelToJson(SearchMoversResponseModel? data) =>
    json.encode(data!.toJson());

class SearchMoversResponseModel {
  SearchMoversResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  Data? data;

  factory SearchMoversResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchMoversResponseModel(
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
  String? startDate;
  String? endDate;
  int? startPrice;
  int? currentPrice;
  int? type;
  int? likes;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        companyId: json["companyId"],
        percentage: json["percentage"],
        startDate: json["startDate"],
        endDate: json["endDate"],
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
        "startDate": startDate,
        "endDate": endDate,
        "startPrice": startPrice,
        "currentPrice": currentPrice,
        "type": type,
        "likes": likes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
