// To parse this JSON data, do
//
//     final odRejectResponse = odRejectResponseFromJson(jsonString);

import 'dart:convert';

OdRejectResponse odRejectResponseFromJson(String str) => OdRejectResponse.fromJson(json.decode(str));

String odRejectResponseToJson(OdRejectResponse data) => json.encode(data.toJson());

class OdRejectResponse {
  String status;
  String message;

  OdRejectResponse({
    required this.status,
    required this.message,
  });

  factory OdRejectResponse.fromJson(Map<String, dynamic> json) => OdRejectResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
