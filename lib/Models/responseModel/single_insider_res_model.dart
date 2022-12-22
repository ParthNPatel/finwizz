// To parse this JSON data, do
//
//     final singleInsiderResponseModel = singleInsiderResponseModelFromJson(jsonString);

import 'dart:convert';

SingleInsiderResponseModel singleInsiderResponseModelFromJson(String str) =>
    SingleInsiderResponseModel.fromJson(json.decode(str));

String singleInsiderResponseModelToJson(SingleInsiderResponseModel data) =>
    json.encode(data.toJson());

class SingleInsiderResponseModel {
  SingleInsiderResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  Data? data;

  factory SingleInsiderResponseModel.fromJson(Map<String, dynamic> json) =>
      SingleInsiderResponseModel(
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
    this.name,
    this.createdAt,
    this.updatedAt,
    this.insiders,
    this.dataId,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  Insiders? insiders;
  String? dataId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        insiders: Insiders.fromJson(json["insiders"]),
        dataId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "insiders": insiders!.toJson(),
        "id": dataId,
      };
}

class Insiders {
  Insiders({
    this.sharesSold,
    this.sharesBought,
    this.id,
    this.companyId,
    this.createdAt,
    this.table,
    this.updateDate,
    this.updatedAt,
  });

  Shares? sharesSold;
  Shares? sharesBought;
  String? id;
  String? companyId;
  DateTime? createdAt;
  List<Table>? table;
  DateTime? updateDate;
  DateTime? updatedAt;

  factory Insiders.fromJson(Map<String, dynamic> json) => Insiders(
        sharesSold: Shares.fromJson(json["sharesSold"]),
        sharesBought: Shares.fromJson(json["sharesBought"]),
        id: json["_id"],
        companyId: json["companyId"],
        createdAt: DateTime.parse(json["createdAt"]),
        table: List<Table>.from(json["table"].map((x) => Table.fromJson(x))),
        updateDate: DateTime.parse(json["updateDate"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "sharesSold": sharesSold!.toJson(),
        "sharesBought": sharesBought!.toJson(),
        "_id": id,
        "companyId": companyId,
        "createdAt": createdAt!.toIso8601String(),
        "table": List<dynamic>.from(table!.map((x) => x.toJson())),
        "updateDate": updateDate!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

class Shares {
  Shares({
    this.shares,
    this.person,
  });

  int? shares;
  int? person;

  factory Shares.fromJson(Map<String, dynamic> json) => Shares(
        shares: json["shares"],
        person: json["person"],
      );

  Map<String, dynamic> toJson() => {
        "shares": shares,
        "person": person,
      };
}

class Table {
  Table({
    this.personCategory,
    this.shares,
    this.value,
    this.transactionType,
    this.mode,
    this.id,
  });

  String? personCategory;
  int? shares;
  int? value;
  String? transactionType;
  String? mode;
  String? id;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        personCategory: json["personCategory"],
        shares: json["shares"],
        value: json["value"],
        transactionType: json["transactionType"],
        mode: json["mode"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "personCategory": personCategory,
        "shares": shares,
        "value": value,
        "transactionType": transactionType,
        "mode": mode,
        "_id": id,
      };
}
