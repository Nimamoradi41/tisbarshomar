// To parse this JSON data, do
//
//     final modeldatalogin = modeldataloginFromJson(jsonString);

import 'dart:convert';

Modeldatalogin modeldataloginFromJson(String str) => Modeldatalogin.fromJson(json.decode(str));

String modeldataloginToJson(Modeldatalogin data) => json.encode(data.toJson());

class Modeldatalogin {
  Modeldatalogin({
    required this.data,
    required this.isSuccess,
    required this.statusCode,
    required this.message,
  });

  Data data;
  bool isSuccess;
  int statusCode;
  String message;

  factory Modeldatalogin.fromJson(Map<String, dynamic> json) => Modeldatalogin(
    data: Data.fromJson(json["data"])  as Data,
    isSuccess: json["isSuccess"]as bool,
    statusCode: json["statusCode"]as int,
    message: json["message"]as String,
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "isSuccess": isSuccess,
    "statusCode": statusCode,
    "message": message,
  };
}

class Data {
  Data({
    required this.status,
    required this.securityKey,
  });

  int status;
  String securityKey;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"]as int,
    securityKey: json["securityKey"]as String,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "securityKey": securityKey,
  };
}
