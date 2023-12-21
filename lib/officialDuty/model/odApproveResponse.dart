// To parse this JSON data, do
//
//     final odApproveResponse = odApproveResponseFromJson(jsonString);

import 'dart:convert';

OdApproveResponse odApproveResponseFromJson(String str) => OdApproveResponse.fromJson(json.decode(str));

String odApproveResponseToJson(OdApproveResponse data) => json.encode(data.toJson());

class OdApproveResponse {
  List<OdStatus> odStatus;

  OdApproveResponse({
    required this.odStatus,
  });

  factory OdApproveResponse.fromJson(Map<String, dynamic> json) => OdApproveResponse(
    odStatus: List<OdStatus>.from(json["OD_status"].map((x) => OdStatus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "OD_status": List<dynamic>.from(odStatus.map((x) => x.toJson())),
  };
}

class OdStatus {
  String type;
  String msg;

  OdStatus({
    required this.type,
    required this.msg,
  });

  factory OdStatus.fromJson(Map<String, dynamic> json) => OdStatus(
    type: json["type"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "msg": msg,
  };
}
