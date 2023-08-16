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
    data: json["DATA"]!=null? List<Datum>.from(json["DATA"].map((x) => Datum.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "DATA": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String gpdat1;
  String gptime1;
  String reqtypeTxt;
  String gptypeTxt;
  String ename;
  String directindirect;
  String mandt;
  String gpno;
  String werks;
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
  String uname;
  String credt;
  String vfp;
  String gateNo;

  Datum({
    required this.gpdat1,
    required this.gptime1,
    required this.reqtypeTxt,
    required this.gptypeTxt,
    required this.ename,
    required this.directindirect,
    required this.mandt,
    required this.gpno,
    required this.werks,
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
    required this.uname,
    required this.credt,
    required this.vfp,
    required this.gateNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    gpdat1: json["gpdat1"],
    gptime1: json["gptime1"],
    reqtypeTxt: json["reqtypeTxt"],
    gptypeTxt: json["gptypeTxt"],
    ename: json["ename"],
    directindirect: json["directindirect"],
    mandt: json["mandt"],
    gpno: json["gpno"],
    werks: json["werks"],
    gptype: json["gptype"],
    pernr: json["pernr"],
    plans: json["plans"],
    orgeh: json["orgeh"],
    gpdat: json["gpdat"],
    gptime: json["gptime"],
    eindat: json["eindat"],
    eintime: json["eintime"],
    reqtype: json["reqtype"],
    chargeGiven: json["chargeGiven"],
    vplace: json["vplace"],
    purpose1: json["purpose1"],
    uname: json["uname"],
    credt:  json["credt"],
    vfp: json["vfp"],
    gateNo: json["gateNo"],
  );

  factory Datum.fromMap(Map<String, dynamic> map) => Datum(
    gpdat1: map["gpdat1"],
    gptime1: map["gptime1"],
    reqtypeTxt: map["reqtypeTxt"],
    gptypeTxt: map["gptypeTxt"],
    ename: map["ename"],
    directindirect: map["directindirect"],
    mandt: map["mandt"],
    gpno: map["gpno"],
    werks: map["werks"],
    gptype: map["gptype"],
    pernr: map["pernr"],
    plans: map["plans"],
    orgeh: map["orgeh"],
    gpdat: map["gpdat"],
    gptime: map["gptime"],
    eindat: map["eindat"],
    eintime: map["eintime"],
    reqtype: map["reqtype"],
    chargeGiven: map["chargeGiven"],
    vplace: map["vplace"],
    purpose1: map["purpose1"],
    uname: map["uname"],
    credt:  map["credt"],
    vfp: map["vfp"],
    gateNo: map["gateNo"],
  );

  Map<String, dynamic> toJson() => {
    "gpdat1": gpdat1,
    "gptime1": gptime1,
    "reqtypeTxt": reqtypeTxt,
    "gptypeTxt": gptypeTxt,
    "ename": ename,
    "directindirect": directindirect,
    "mandt": mandt,
    "gpno": gpno,
    "werks": werks,
    "gptype": gptype,
    "pernr": pernr,
    "plans": plans,
    "orgeh": orgeh,
    "gpdat": gpdat,
    "gptime": gptime,
    "eindat": eindat,
    "eintime": eintime,
    "reqtype": reqtype,
    "chargeGiven": chargeGiven,
    "vplace": vplace,
    "purpose1": purpose1,
    "uname": uname,
    "credt":  credt,
    "vfp": vfp,
    "gateNo": gateNo,
  };

  @override
  String toString() {
    return 'Datum{gpdat1: $gpdat1, gptime1: $gptime1, reqtypeTxt: $reqtypeTxt, gptypeTxt: $gptypeTxt, ename: $ename, directindirect: $directindirect, mandt: $mandt, gpno: $gpno, werks: $werks, gptype: $gptype, pernr: $pernr, plans: $plans, orgeh: $orgeh, gpdat: $gpdat, gptime: $gptime, eindat: $eindat, eintime: $eintime, reqtype: $reqtype, chargeGiven: $chargeGiven, vplace: $vplace, purpose1: $purpose1, uname: $uname, credt: $credt, vfp: $vfp, gateNo: $gateNo}';
  }
}
