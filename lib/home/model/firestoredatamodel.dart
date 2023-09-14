// To parse this JSON data, do
//
//     final firestoreDataModel = firestoreDataModelFromJson(jsonString);

import 'dart:convert';

FirestoreDataModel firestoreDataModelFromJson(String str) => FirestoreDataModel.fromJson(json.decode(str));

String firestoreDataModelToJson(FirestoreDataModel data) => json.encode(data.toJson());

class FirestoreDataModel {
  String minEmployeeAppVersion;
  String employeeAppUrl;

  FirestoreDataModel({
    required this.minEmployeeAppVersion,
    required this.employeeAppUrl,
  });

  factory FirestoreDataModel.fromJson(Map<String, dynamic> json) => FirestoreDataModel(
    minEmployeeAppVersion: json["minEmployeeAppVersion"],
    employeeAppUrl: json["employeeAppUrl"],
  );

  Map<String, dynamic> toJson() => {
    "minEmployeeAppVersion": minEmployeeAppVersion,
    "employeeAppUrl": employeeAppUrl,
  };
}
