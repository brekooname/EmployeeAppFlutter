// To parse this JSON data, do
//
//     final attendenceCorrResponse = attendenceCorrResponseFromJson(jsonString);

import 'dart:convert';

AttendenceCorrResponse attendenceCorrResponseFromJson(String str) => AttendenceCorrResponse.fromJson(json.decode(str));

String attendenceCorrResponseToJson(AttendenceCorrResponse data) => json.encode(data.toJson());

class AttendenceCorrResponse {
  String status;
  String message;

  AttendenceCorrResponse({
    required this.status,
    required this.message,
  });

  factory AttendenceCorrResponse.fromJson(Map<String, dynamic> json) => AttendenceCorrResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
