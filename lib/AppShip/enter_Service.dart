// To parse this JSON data, do
//
//     final enterService = enterServiceFromJson(jsonString);

import 'dart:convert';

EnterService enterServiceFromJson(String str) => EnterService.fromJson(json.decode(str));

String enterServiceToJson(EnterService data) => json.encode(data.toJson());

class EnterService {
  EnterService({
    this.data,
    required this.isSuccess,
    required this.statusCode,
    required this.message,
  });

  dynamic data;
  bool isSuccess;
  int statusCode;
  String message;

  factory EnterService.fromJson(Map<String, dynamic> json) => EnterService(
    data: json["Data"],
    isSuccess: json["IsSuccess"],
    statusCode: json["StatusCode"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "Data": data,
    "IsSuccess": isSuccess,
    "StatusCode": statusCode,
    "Message": message,
  };
}
