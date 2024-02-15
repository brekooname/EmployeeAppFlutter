// To parse this JSON data, do
//
//     final shiftResponseModel = shiftResponseModelFromJson(jsonString);

import 'dart:convert';

ShiftResponseModel shiftResponseModelFromJson(String str) => ShiftResponseModel.fromJson(json.decode(str));

String shiftResponseModelToJson(ShiftResponseModel data) => json.encode(data.toJson());

class ShiftResponseModel {
  String status;
  String message;

  ShiftResponseModel({
    required this.status,
    required this.message,
  });

  factory ShiftResponseModel.fromJson(Map<String, dynamic> json) => ShiftResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
