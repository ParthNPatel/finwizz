// To parse this JSON data, do
//
//     final getNotificationResponseModel = getNotificationResponseModelFromJson(jsonString);

import 'dart:convert';

GetNotificationResponseModel getNotificationResponseModelFromJson(String str) =>
    GetNotificationResponseModel.fromJson(json.decode(str));

String getNotificationResponseModelToJson(GetNotificationResponseModel data) =>
    json.encode(data.toJson());

class GetNotificationResponseModel {
  GetNotificationResponseModel({
    this.flag,
    this.message,
  });

  bool? flag;
  List<Message>? message;

  factory GetNotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationResponseModel(
        flag: json["flag"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "message": List<dynamic>.from(message!.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    this.id,
    this.title,
    this.body,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? title;
  String? body;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        title: json["title"],
        body: json["body"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "userId": userId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
