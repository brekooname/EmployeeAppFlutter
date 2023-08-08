// To parse this JSON data, do
//
//     final LeaveApproveResponse = odApproveResponseFromJson(jsonString);

import 'dart:convert';

List<LeaveApproveResponse> odApproveResponseFromJson(String str) => List<LeaveApproveResponse>.from(json.decode(str).map((x) => LeaveApproveResponse.fromJson(x)));

String odApproveResponseToJson(List<LeaveApproveResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveApproveResponse {
  String type;
  String msg;

  LeaveApproveResponse({
    required this.type,
    required this.msg,
  });

  factory LeaveApproveResponse.fromJson(Map<String, dynamic> json) => LeaveApproveResponse(
    type: json["type"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "msg": msg,
  };
}
