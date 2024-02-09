// To parse this JSON data, do
//
//     final coffRequest = coffRequestFromJson(jsonString);

import 'dart:convert';

List<coffRequest> coffRequestFromJson(String str) => List<coffRequest>.from(json.decode(str).map((x) => coffRequest.fromJson(x)));

String coffRequestToJson(List<coffRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class coffRequest {
  String pernr;
  String coffDate;
  String indz;
  String iodz;
  String totdz;
  String applyDate;
  String pernr2;
  String reason;
  String leavetype;

  coffRequest({
    required this.pernr,
    required this.coffDate,
    required this.indz,
    required this.iodz,
    required this.totdz,
    required this.applyDate,
    required this.pernr2,
    required this.reason,
    required this.leavetype,
  });

  factory coffRequest.fromJson(Map<String, dynamic> json) => coffRequest(
    pernr: json["PERNR"],
    coffDate: json["COFF_DATE"],
    indz: json["INDZ"],
    iodz: json["IODZ"],
    totdz: json["TOTDZ"],
    applyDate: json["APPLY_DATE"],
    pernr2: json["PERNR2"],
    reason: json["REASON"],
    leavetype: json["LEAVETYPE"],
  );

  Map<String, dynamic> toJson() => {
    "PERNR": pernr,
    "COFF_DATE": coffDate,
    "INDZ": indz,
    "IODZ": iodz,
    "TOTDZ": totdz,
    "APPLY_DATE": applyDate,
    "PERNR2": pernr2,
    "REASON": reason,
    "LEAVETYPE": leavetype,
  };

  @override
  String toString() {
    return 'coffRequest{pernr: $pernr, coffDate: $coffDate, indz: $indz, iodz: $iodz, totdz: $totdz, applyDate: $applyDate, pernr2: $pernr2, reason: $reason, leavetype: $leavetype}';
  }
}
