// To parse this JSON data, do
//
//     final approveStatusResponse = approveStatusResponseFromJson(jsonString);

import 'dart:convert';

ApproveStatusResponse approveStatusResponseFromJson(String str) => ApproveStatusResponse.fromJson(json.decode(str));

String approveStatusResponseToJson(ApproveStatusResponse data) => json.encode(data.toJson());

class ApproveStatusResponse {
  String status;
  String message;

  ApproveStatusResponse({
    required this.status,
    required this.message,
  });

  factory ApproveStatusResponse.fromJson(Map<String, dynamic> json) => ApproveStatusResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
