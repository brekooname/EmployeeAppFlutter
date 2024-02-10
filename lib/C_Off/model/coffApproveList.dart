// To parse this JSON data, do
//
//     final COffApprovalList = COffApprovalListFromJson(jsonString);

import 'dart:convert';

COffApprovalList COffApprovalListFromJson(String str) => COffApprovalList.fromJson(json.decode(str));

String COffApprovalListToJson(COffApprovalList data) => json.encode(data.toJson());

class COffApprovalList {
  String status;
  String message;
  List<Response> response;

  COffApprovalList({
    required this.status,
    required this.message,
    required this.response,
  });

  factory COffApprovalList.fromJson(Map<String, dynamic> json) => COffApprovalList(
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
  String ename;
  String mandt;
  String pernr;
  String coffDate;
  String applyDate;
  String indz;
  String iodz;
  String totdz;
  String pernr2;
  String pernr3;
  String reason;
  String crtDat;
  String crtTims;
  String appBy;
  String app;
  String rej;
  String appRejDat;
  String appRejTims;
  String leavetype;

  Response({
    required this.ename,
    required this.mandt,
    required this.pernr,
    required this.coffDate,
    required this.applyDate,
    required this.indz,
    required this.iodz,
    required this.totdz,
    required this.pernr2,
    required this.pernr3,
    required this.reason,
    required this.crtDat,
    required this.crtTims,
    required this.appBy,
    required this.app,
    required this.rej,
    required this.appRejDat,
    required this.appRejTims,
    required this.leavetype,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    ename: json["ename"],
    mandt: json["mandt"],
    pernr: json["pernr"],
    coffDate: json["coff_date"],
    applyDate: json["apply_date"],
    indz: json["indz"],
    iodz: json["iodz"],
    totdz: json["totdz"],
    pernr2: json["pernr2"],
    pernr3: json["pernr3"],
    reason: json["reason"],
    crtDat: json["crt_dat"],
    crtTims: json["crt_tims"],
    appBy: json["app_by"],
    app: json["app"],
    rej: json["rej"],
    appRejDat: json["app_rej_dat"],
    appRejTims: json["app_rej_tims"],
    leavetype: json["leavetype"],
  );

  Map<String, dynamic> toJson() => {
    "ename": ename,
    "mandt": mandt,
    "pernr": pernr,
    "coff_date": coffDate,
    "apply_date": applyDate,
    "indz": indz,
    "iodz": iodz,
    "totdz": totdz,
    "pernr2": pernr2,
    "pernr3": pernr3,
    "reason": reason,
    "crt_dat": crtDat,
    "crt_tims": crtTims,
    "app_by": appBy,
    "app": app,
    "rej": rej,
    "app_rej_dat": appRejDat,
    "app_rej_tims": appRejTims,
    "leavetype": leavetype,
  };

  @override
  String toString() {
    return 'Response{ename: $ename, mandt: $mandt, pernr: $pernr, coffDate: $coffDate, applyDate: $applyDate, indz: $indz, iodz: $iodz, totdz: $totdz, pernr2: $pernr2, pernr3: $pernr3, reason: $reason, crtDat: $crtDat, crtTims: $crtTims, appBy: $appBy, app: $app, rej: $rej, appRejDat: $appRejDat, appRejTims: $appRejTims, leavetype: $leavetype}';
  }
}
