// To parse this JSON data, do
//
//     final updateUserResponseModel = updateUserResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateUserResponseModel updateUserResponseModelFromJson(String str) =>
    UpdateUserResponseModel.fromJson(json.decode(str));

String updateUserResponseModelToJson(UpdateUserResponseModel data) =>
    json.encode(data.toJson());

class UpdateUserResponseModel {
  UpdateUserResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  Data? data;

  factory UpdateUserResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserResponseModel(
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
    this.phone,
    this.refferalCode,
    this.newsAlerts,
    this.portfolioAlerts,
    this.likedNews,
    this.favouriteNews,
    this.likedMovers,
    this.addedStocks,
    this.refferalCount,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? phone;
  String? refferalCode;
  bool? newsAlerts;
  bool? portfolioAlerts;
  List<String>? likedNews;
  List<dynamic>? favouriteNews;
  List<dynamic>? likedMovers;
  List<String>? addedStocks;
  int? refferalCount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        phone: json["phone"],
        refferalCode: json["refferalCode"],
        newsAlerts: json["newsAlerts"],
        portfolioAlerts: json["portfolioAlerts"],
        likedNews: List<String>.from(json["likedNews"].map((x) => x)),
        favouriteNews: List<dynamic>.from(json["favouriteNews"].map((x) => x)),
        likedMovers: List<dynamic>.from(json["likedMovers"].map((x) => x)),
        addedStocks: List<String>.from(json["addedStocks"].map((x) => x)),
        refferalCount: json["refferalCount"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "refferalCode": refferalCode,
        "newsAlerts": newsAlerts,
        "portfolioAlerts": portfolioAlerts,
        "likedNews": List<dynamic>.from(likedNews!.map((x) => x)),
        "favouriteNews": List<dynamic>.from(favouriteNews!.map((x) => x)),
        "likedMovers": List<dynamic>.from(likedMovers!.map((x) => x)),
        "addedStocks": List<dynamic>.from(addedStocks!.map((x) => x)),
        "refferalCount": refferalCount,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
