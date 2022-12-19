// To parse this JSON data, do
//
//     final contactUsResponseModel = contactUsResponseModelFromJson(jsonString);

import 'dart:convert';

ContactUsResponseModel contactUsResponseModelFromJson(String str) =>
    ContactUsResponseModel.fromJson(json.decode(str));

String contactUsResponseModelToJson(ContactUsResponseModel data) =>
    json.encode(data.toJson());

class ContactUsResponseModel {
  ContactUsResponseModel({
    this.flag,
    this.data,
  });

  bool? flag;
  Data? data;

  factory ContactUsResponseModel.fromJson(Map<String, dynamic> json) =>
      ContactUsResponseModel(
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
    this.name,
    this.email,
    this.message,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  String? name;
  String? email;
  String? message;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        message: json["message"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "message": message,
        "_id": id,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
