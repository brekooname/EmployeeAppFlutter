// To parse this JSON data, do
//
//     final gatePassResponse = gatePassResponseFromJson(jsonString);

import 'dart:convert';

List<GatePassResponse> gatePassResponseFromJson(String str) => List<GatePassResponse>.from(json.decode(str).map((x) => GatePassResponse.fromJson(x)));

String gatePassResponseToJson(List<GatePassResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GatePassResponse {
  String msgtyp;
  String text;

  GatePassResponse({
    required this.msgtyp,
    required this.text,
  });

  factory GatePassResponse.fromJson(Map<String, dynamic> json) => GatePassResponse(
    msgtyp: json["msgtyp"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "msgtyp": msgtyp,
    "text": text,
  };
}
