// To parse this JSON data, do
//
//     final odApproveResponse = odApproveResponseFromJson(jsonString);

import 'dart:convert';

List<OdApproveResponse> odApproveResponseFromJson(String str) => List<OdApproveResponse>.from(json.decode(str).map((x) => OdApproveResponse.fromJson(x)));

String odApproveResponseToJson(List<OdApproveResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OdApproveResponse {
  String type;
  String msg;

  OdApproveResponse({
    required this.type,
    required this.msg,
  });

  factory OdApproveResponse.fromJson(Map<String, dynamic> json) => OdApproveResponse(
    type: json["type"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "msg": msg,
  };
}
