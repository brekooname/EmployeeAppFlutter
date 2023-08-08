// To parse this JSON data, do
//
//     final leaveRejectResponse = leaveRejectResponseFromJson(jsonString);

import 'dart:convert';

LeaveRejectResponse leaveRejectResponseFromJson(String str) => LeaveRejectResponse.fromJson(json.decode(str));

String leaveRejectResponseToJson(LeaveRejectResponse data) => json.encode(data.toJson());

class LeaveRejectResponse {
  String status;
  String message;

  LeaveRejectResponse({
    required this.status,
    required this.message,
  });

  factory LeaveRejectResponse.fromJson(Map<String, dynamic> json) => LeaveRejectResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
