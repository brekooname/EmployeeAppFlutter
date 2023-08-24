// To parse this JSON data, do
//
//     final departmentModel = departmentModelFromJson(jsonString);

import 'dart:convert';

DepartmentModel departmentModelFromJson(String str) => DepartmentModel.fromJson(json.decode(str));

String departmentModelToJson(DepartmentModel data) => json.encode(data.toJson());

class DepartmentModel {
  String status;
  String message;
  List<Response> response;

  DepartmentModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
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
