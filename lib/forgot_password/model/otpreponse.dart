// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  String status;
  String code;
  String messageId;
  String description;

  OtpResponse({
    required this.status,
    required this.code,
    required this.messageId,
    required this.description,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
    status: json["Status"]!=null?json["Status"]:"",
    code: json["Code"]!=null?json["Code"]:"",
    messageId: json["Message-Id"]!=null?json["Message-Id"]:"",
    description: json["Description"]!=null?json["Description"]:"",
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Code": code,
    "Message-Id": messageId,
    "Description": description,
  };
}
