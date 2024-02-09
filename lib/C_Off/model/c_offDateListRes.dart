// To parse this JSON data, do
//
//     final coffDateList = coffDateListFromJson(jsonString);

import 'dart:convert';

coffDateList coffDateListFromJson(String str) => coffDateList.fromJson(json.decode(str));

String coffDateListToJson(coffDateList data) => json.encode(data.toJson());

class coffDateList {
  String status;
  String message;
  List<Response> response;

  coffDateList({
    required this.status,
    required this.message,
    required this.response,
  });

  factory coffDateList.fromJson(Map<String, dynamic> json) => coffDateList(
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
  String mandt;
  String pernr;
  String begdat;
  String del;
  String bukrs;
  String werks;
  String indz;
  String enddat;
  String iodz;
  String totdz;
  String shift;
  String ibdz;
  String iotdz;
  String atnStatus;

  Response({
    required this.mandt,
    required this.pernr,
    required this.begdat,
    required this.del,
    required this.bukrs,
    required this.werks,
    required this.indz,
    required this.enddat,
    required this.iodz,
    required this.totdz,
    required this.shift,
    required this.ibdz,
    required this.iotdz,
    required this.atnStatus,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    mandt: json["mandt"],
    pernr: json["pernr"],
    begdat: json["begdat"],
    del: json["del"],
    bukrs: json["bukrs"],
    werks: json["werks"],
    indz: json["indz"],
    enddat: json["enddat"],
    iodz: json["iodz"],
    totdz: json["totdz"],
    shift: json["shift"],
    ibdz: json["ibdz"],
    iotdz: json["iotdz"],
    atnStatus: json["atn_status"],
  );

  Map<String, dynamic> toJson() => {
    "mandt": mandt,
    "pernr": pernr,
    "begdat": begdat,
    "del": del,
    "bukrs": bukrs,
    "werks": werks,
    "indz": indz,
    "enddat": enddat,
    "iodz": iodz,
    "totdz": totdz,
    "shift": shift,
    "ibdz": ibdz,
    "iotdz": iotdz,
    "atn_status": atnStatus,
  };

  @override
  String toString() {
    return 'Response{mandt: $mandt, pernr: $pernr, begdat: $begdat, del: $del, bukrs: $bukrs, werks: $werks, indz: $indz, enddat: $enddat, iodz: $iodz, totdz: $totdz, shift: $shift, ibdz: $ibdz, iotdz: $iotdz, atnStatus: $atnStatus}';
  }
}
