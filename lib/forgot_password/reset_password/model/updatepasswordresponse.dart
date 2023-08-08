// To parse this JSON data, do
//
//     final UpdatePasswordResponse = loginModelResponseFromJson(jsonString);

import 'dart:convert';

List<UpdatePasswordResponse> loginModelResponseFromJson(String str) => List<UpdatePasswordResponse>.from(json.decode(str).map((x) => UpdatePasswordResponse.fromJson(x)));

String loginModelResponseToJson(List<UpdatePasswordResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdatePasswordResponse {
  String msg;

  UpdatePasswordResponse({
    required this.msg,
  });

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) => UpdatePasswordResponse(
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
  };
}
