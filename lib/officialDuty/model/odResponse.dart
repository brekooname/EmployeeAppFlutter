// To parse this JSON data, do
//
//     final odRespons = odResponsFromJson(jsonString);

import 'dart:convert';

List<OdResponse> odResponsFromJson(String str) => List<OdResponse>.from(json.decode(str).map((x) => OdResponse.fromJson(x)));

String odResponsToJson(List<OdResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OdResponse {
  String name;

  OdResponse({
    required this.name,
  });

  factory OdResponse.fromJson(Map<String, dynamic> json) => OdResponse(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
