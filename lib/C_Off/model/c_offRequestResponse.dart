// To parse this JSON data, do
//
//     final coffRequestResponse = coffRequestResponseFromJson(jsonString);

import 'dart:convert';

coffRequestResponse coffRequestResponseFromJson(String str) => coffRequestResponse.fromJson(json.decode(str));

String coffRequestResponseToJson(coffRequestResponse data) => json.encode(data.toJson());

class coffRequestResponse {
  String status;
  String message;

  coffRequestResponse({
    required this.status,
    required this.message,
  });

  factory coffRequestResponse.fromJson(Map<String, dynamic> json) => coffRequestResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
