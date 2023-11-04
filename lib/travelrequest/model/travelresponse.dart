// To parse this JSON data, do
//
//     final travelRequestResponse = travelRequestResponseFromJson(jsonString);

import 'dart:convert';

TravelRequestResponse travelRequestResponseFromJson(String str) => TravelRequestResponse.fromJson(json.decode(str));

String travelRequestResponseToJson(TravelRequestResponse data) => json.encode(data.toJson());

class TravelRequestResponse {
  String status;
  String message;

  TravelRequestResponse({
    required this.status,
    required this.message,
  });

  factory TravelRequestResponse.fromJson(Map<String, dynamic> json) => TravelRequestResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };

  @override
  String toString() {
    return 'TravelRequestResponse{status: $status, message: $message}';
  }
}
