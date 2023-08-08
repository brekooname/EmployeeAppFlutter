// To parse this JSON data, do
//
//     final leaveRequestModelResponse = leaveRequestModelResponseFromJson(jsonString);

import 'dart:convert';

List<LeaveRequestModelResponse> leaveRequestModelResponseFromJson(String str) => List<LeaveRequestModelResponse>.from(json.decode(str).map((x) => LeaveRequestModelResponse.fromJson(x)));

String leaveRequestModelResponseToJson(List<LeaveRequestModelResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveRequestModelResponse {
  String name;

  LeaveRequestModelResponse({
    required this.name,
  });

  factory LeaveRequestModelResponse.fromJson(Map<String, dynamic> json) => LeaveRequestModelResponse(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
