// To parse this JSON data, do
//
//     final pendingGatePassResponse = pendingGatePassResponseFromJson(jsonString);

import 'dart:convert';

PendingGatePassResponse pendingGatePassResponseFromJson(String str) => PendingGatePassResponse.fromJson(json.decode(str));

String pendingGatePassResponseToJson(PendingGatePassResponse data) => json.encode(data.toJson());

class PendingGatePassResponse {
  List<Datum> data;

  PendingGatePassResponse({
    required this.data,
  });

  factory PendingGatePassResponse.fromJson(Map<String, dynamic> json) => PendingGatePassResponse(
    data: List<Datum>.from(json["DATA"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "DATA": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String chk;
  String sno;
  String gpdat1;
  String gptime1;
  String eindat1;
  String eintime1;
  String reqtypeTxt;
  String gptypeTxt;
  String pernr1;
  String ename;
  String directindirect;
  String mandt;
  String gpno;
  String werks;
  String del;
  String gptype;
  String pernr;
  String plans;
  String orgeh;
  String gpdat;
  String gptime;
  String eindat;
  String eintime;
  String reqtype;
  String chargeGiven;
  String vplace;
  String purpose1;
  String purpose2;
  String hod;
  String uname;
  String credt;
  String chby;
  String chdat;
  String vfp;
  String gateNo;
  String discp;
  String closedDate;
  String closed;
  String remark;
  String rejected;
  String approve;
  String hodAppRejDate;
  String appRejBy;

  Datum({
    required this.chk,
    required this.sno,
    required this.gpdat1,
    required this.gptime1,
    required this.eindat1,
    required this.eintime1,
    required this.reqtypeTxt,
    required this.gptypeTxt,
    required this.pernr1,
    required this.ename,
    required this.directindirect,
    required this.mandt,
    required this.gpno,
    required this.werks,
    required this.del,
    required this.gptype,
    required this.pernr,
    required this.plans,
    required this.orgeh,
    required this.gpdat,
    required this.gptime,
    required this.eindat,
    required this.eintime,
    required this.reqtype,
    required this.chargeGiven,
    required this.vplace,
    required this.purpose1,
    required this.purpose2,
    required this.hod,
    required this.uname,
    required this.credt,
    required this.chby,
    required this.chdat,
    required this.vfp,
    required this.gateNo,
    required this.discp,
    required this.closedDate,
    required this.closed,
    required this.remark,
    required this.rejected,
    required this.approve,
    required this.hodAppRejDate,
    required this.appRejBy,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    chk: json["chk"],
    sno: json["sno"],
    gpdat1: json["gpdat1"],
    gptime1: json["gptime1"],
    eindat1: json["eindat1"],
    eintime1: json["eintime1"],
    reqtypeTxt: json["reqtype_txt"],
    gptypeTxt: json["gptype_txt"],
    pernr1: json["pernr1"],
    ename: json["ename"],
    directindirect: json["directindirect"],
    mandt: json["mandt"],
    gpno: json["gpno"],
    werks: json["werks"],
    del: json["del"],
    gptype: json["gptype"],
    pernr: json["pernr"],
    plans: json["plans"],
    orgeh: json["orgeh"],
    gpdat: json["gpdat"],
    gptime: json["gptime"],
    eindat: json["eindat"],
    eintime: json["eintime"],
    reqtype: json["reqtype"],
    chargeGiven: json["charge_given"],
    vplace: json["vplace"],
    purpose1: json["purpose1"],
    purpose2: json["purpose2"],
    hod: json["hod"],
    uname: json["uname"],
    credt: json["credt"],
    chby: json["chby"],
    chdat: json["chdat"],
    vfp: json["vfp"],
    gateNo: json["gate_no"],
    discp: json["discp"],
    closedDate: json["closed_date"],
    closed: json["closed"],
    remark: json["remark"],
    rejected: json["rejected"],
    approve: json["approve"],
    hodAppRejDate: json["hod_app_rej_date"],
    appRejBy: json["app_rej_by"],
  );

  Map<String, dynamic> toJson() => {
    "chk": chk,
    "sno": sno,
    "gpdat1": gpdat1,
    "gptime1": gptime1,
    "eindat1": eindat1,
    "eintime1": eintime1,
    "reqtype_txt": reqtypeTxt,
    "gptype_txt": gptypeTxt,
    "pernr1": pernr1,
    "ename": ename,
    "directindirect": directindirect,
    "mandt": mandt,
    "gpno": gpno,
    "werks": werks,
    "del": del,
    "gptype": gptype,
    "pernr": pernr,
    "plans": plans,
    "orgeh": orgeh,
    "gpdat": gpdat,
    "gptime": gptime,
    "eindat": eindat,
    "eintime": eintime,
    "reqtype": reqtype,
    "charge_given": chargeGiven,
    "vplace": vplace,
    "purpose1": purpose1,
    "purpose2": purpose2,
    "hod": hod,
    "uname": uname,
    "credt": credt,
    "chby": chby,
    "chdat": chdat,
    "vfp": vfp,
    "gate_no": gateNo,
    "discp": discp,
    "closed_date": closedDate,
    "closed": closed,
    "remark": remark,
    "rejected": rejected,
    "approve": approve,
    "hod_app_rej_date": hodAppRejDate,
    "app_rej_by": appRejBy,
  };
}
