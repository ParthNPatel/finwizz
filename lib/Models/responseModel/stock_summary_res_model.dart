// // To parse this JSON data, do
// //
// //     final stockSummaryResponseModel = stockSummaryResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// StockSummaryResponseModel stockSummaryResponseModelFromJson(String str) =>
//     StockSummaryResponseModel.fromJson(json.decode(str));
//
// String stockSummaryResponseModelToJson(StockSummaryResponseModel data) =>
//     json.encode(data.toJson());
//
// class StockSummaryResponseModel {
//   StockSummaryResponseModel({
//     this.flag,
//     this.data,
//   });
//
//   bool? flag;
//   Data? data;
//
//   factory StockSummaryResponseModel.fromJson(Map<String, dynamic> json) =>
//       StockSummaryResponseModel(
//         flag: json["flag"],
//         data: Data.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "flag": flag,
//         "data": data!.toJson(),
//       };
// }
//
// class Data {
//   Data({
//     this.refferalCount,
//     this.id,
//     this.phone,
//     this.addedStocks,
//     this.createdAt,
//     this.favouriteNews,
//     this.likedNews,
//     this.updatedAt,
//   });
//
//   int? refferalCount;
//   String? id;
//   String? phone;
//   List<AddedStock>? addedStocks;
//   DateTime? createdAt;
//   List<String>? favouriteNews;
//   List<String>? likedNews;
//   DateTime? updatedAt;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         refferalCount: json["refferalCount"],
//         id: json["_id"],
//         phone: json["phone"],
//         addedStocks: List<AddedStock>.from(
//             json["addedStocks"].map((x) => AddedStock.fromJson(x))),
//         createdAt: DateTime.parse(json["createdAt"]),
//         favouriteNews: List<String>.from(json["favouriteNews"].map((x) => x)),
//         likedNews: List<String>.from(json["likedNews"].map((x) => x)),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "refferalCount": refferalCount,
//         "_id": id,
//         "phone": phone,
//         "addedStocks": List<dynamic>.from(addedStocks!.map((x) => x.toJson())),
//         "createdAt": createdAt!.toIso8601String(),
//         "favouriteNews": List<dynamic>.from(favouriteNews!.map((x) => x)),
//         "likedNews": List<dynamic>.from(likedNews!.map((x) => x)),
//         "updatedAt": updatedAt!.toIso8601String(),
//       };
// }
//
// class AddedStock {
//   AddedStock({
//     this.id,
//     this.name,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   String? id;
//   String? name;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory AddedStock.fromJson(Map<String, dynamic> json) => AddedStock(
//         id: json["_id"],
//         name: json["name"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "createdAt": createdAt!.toIso8601String(),
//         "updatedAt": updatedAt!.toIso8601String(),
//       };
// }

// To parse this JSON data, do
//
//     final stockSummaryResponseModel = stockSummaryResponseModelFromJson(jsonString);

import 'dart:convert';

StockSummaryResponseModel stockSummaryResponseModelFromJson(String str) =>
    StockSummaryResponseModel.fromJson(json.decode(str));

String stockSummaryResponseModelToJson(StockSummaryResponseModel data) =>
    json.encode(data.toJson());

class StockSummaryResponseModel {
  StockSummaryResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  List<AddedStock>? data;

  factory StockSummaryResponseModel.fromJson(Map<String, dynamic> json) =>
      StockSummaryResponseModel(
        flag: json["flag"],
        data: List<AddedStock>.from(
            json["data"].map((x) => AddedStock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AddedStock {
  AddedStock({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.positive,
    this.negative,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? positive;
  int? negative;

  factory AddedStock.fromJson(Map<String, dynamic> json) => AddedStock(
        id: json["_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        positive: json["positive"],
        negative: json["negative"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "positive": positive,
        "negative": negative,
      };
}
