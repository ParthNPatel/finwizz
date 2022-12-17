// To parse this JSON data, do
//
//     final insiderResponseModel = insiderResponseModelFromJson(jsonString);

import 'dart:convert';

InsiderResponseModel insiderResponseModelFromJson(String str) =>
    InsiderResponseModel.fromJson(json.decode(str));

String insiderResponseModelToJson(InsiderResponseModel data) =>
    json.encode(data.toJson());

class InsiderResponseModel {
  InsiderResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  List<Insider>? data;

  factory InsiderResponseModel.fromJson(Map<String, dynamic> json) =>
      InsiderResponseModel(
        flag: json["flag"],
        data: List<Insider>.from(json["data"].map((x) => Insider.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Insider {
  Insider({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.insiders,
    this.InsiderId,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  Insiders? insiders;
  String? InsiderId;

  factory Insider.fromJson(Map<String, dynamic> json) => Insider(
        id: json["_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        insiders: json["insiders"] == null
            ? null
            : Insiders.fromJson(json["insiders"]),
        InsiderId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "insiders": insiders == null ? null : insiders!.toJson(),
        "id": InsiderId,
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
