// To parse this JSON data, do
//
//     final coffAppRejModel = coffAppRejModelFromJson(jsonString);

import 'dart:convert';

CoffAppRejModel coffAppRejModelFromJson(String str) => CoffAppRejModel.fromJson(json.decode(str));

String coffAppRejModelToJson(CoffAppRejModel data) => json.encode(data.toJson());

class CoffAppRejModel {
  String pernr;
  String coffDate;
  String applyDate;
  String appBy;
  String app;

  CoffAppRejModel({
    required this.pernr,
    required this.coffDate,
    required this.applyDate,
    required this.appBy,
    required this.app,
  });

  factory CoffAppRejModel.fromJson(Map<String, dynamic> json) => CoffAppRejModel(
    pernr: json["PERNR"],
    coffDate: json["COFF_DATE"],
    applyDate: json["APPLY_DATE"],
    appBy: json["APP_BY"],
    app: json["APP"],
  );

  Map<String, dynamic> toJson() => {
    "PERNR": pernr,
    "COFF_DATE": coffDate,
    "APPLY_DATE": applyDate,
    "APP_BY": appBy,
    "APP": app,
  };
}
