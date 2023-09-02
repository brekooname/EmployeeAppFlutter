// To parse this JSON data, do
//
//     final subDepartmentModel = subDepartmentModelFromJson(jsonString);

import 'dart:convert';

SubDepartmentModel subDepartmentModelFromJson(String str) => SubDepartmentModel.fromJson(json.decode(str));

String subDepartmentModelToJson(SubDepartmentModel data) => json.encode(data.toJson());

class SubDepartmentModel {
  String status;
  String message;
  List<Response> response;

  SubDepartmentModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory SubDepartmentModel.fromJson(Map<String, dynamic> json) => SubDepartmentModel(
    status: json["status"],
    message: json["message"],
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String depId;
  String departName;

  Response({
    required this.depId,
    required this.departName,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    depId: json["dep_id"],
    departName: json["depart_name"],
  );

  Map<String, dynamic> toJson() => {
    "dep_id": depId,
    "depart_name": departName,
  };
}
