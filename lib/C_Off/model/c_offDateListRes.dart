// To parse this JSON data, do
//
//     final coffDateList = coffDateListFromJson(jsonString);

import 'dart:convert';

CoffDateList coffDateListFromJson(String str) => CoffDateList.fromJson(json.decode(str));

String coffDateListToJson(CoffDateList data) => json.encode(data.toJson());

class CoffDateList {
  String status;
  String message;
  List<Response> response;

  CoffDateList({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CoffDateList.fromJson(Map<String, dynamic> json) => CoffDateList(
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
  String exPernr;
  String loadtm;
  String loaddt;
  String uname;
  String sysid;
  String ipaddr;
  String host;
  String chLoadtm;
  String chLoaddt;
  String chUname;
  String chSysid;
  String chIpaddr;
  String chHost;
  String reason;
  String leaveTyp;
  String leaveHrs;
  String tcode;
  String inLatLong;
  String outLatLong;
  String inFileNam;
  String outFileNam;
  String deviceName;
  String recordIndex;
  String lateMin;

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
    required this.exPernr,
    required this.loadtm,
    required this.loaddt,
    required this.uname,
    required this.sysid,
    required this.ipaddr,
    required this.host,
    required this.chLoadtm,
    required this.chLoaddt,
    required this.chUname,
    required this.chSysid,
    required this.chIpaddr,
    required this.chHost,
    required this.reason,
    required this.leaveTyp,
    required this.leaveHrs,
    required this.tcode,
    required this.inLatLong,
    required this.outLatLong,
    required this.inFileNam,
    required this.outFileNam,
    required this.deviceName,
    required this.recordIndex,
    required this.lateMin,
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
    exPernr: json["ex_pernr"],
    loadtm: json["loadtm"],
    loaddt: json["loaddt"],
    uname: json["uname"],
    sysid: json["sysid"],
    ipaddr: json["ipaddr"],
    host: json["host"],
    chLoadtm: json["ch_loadtm"],
    chLoaddt: json["ch_loaddt"],
    chUname: json["ch_uname"],
    chSysid: json["ch_sysid"],
    chIpaddr: json["ch_ipaddr"],
    chHost: json["ch_host"],
    reason: json["reason"],
    leaveTyp: json["leave_typ"],
    leaveHrs: json["leave_hrs"],
    tcode: json["tcode"],
    inLatLong: json["in_lat_long"],
    outLatLong: json["out_lat_long"],
    inFileNam: json["in_file_nam"],
    outFileNam: json["out_file_nam"],
    deviceName: json["device_name"],
    recordIndex: json["record_index"],
    lateMin: json["late_min"],
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
    "ex_pernr": exPernr,
    "loadtm": loadtm,
    "loaddt": loaddt,
    "uname": uname,
    "sysid": sysid,
    "ipaddr": ipaddr,
    "host": host,
    "ch_loadtm": chLoadtm,
    "ch_loaddt": chLoaddt,
    "ch_uname": chUname,
    "ch_sysid": chSysid,
    "ch_ipaddr": chIpaddr,
    "ch_host": chHost,
    "reason": reason,
    "leave_typ": leaveTyp,
    "leave_hrs": leaveHrs,
    "tcode": tcode,
    "in_lat_long": inLatLong,
    "out_lat_long": outLatLong,
    "in_file_nam": inFileNam,
    "out_file_nam": outFileNam,
    "device_name": deviceName,
    "record_index": recordIndex,
    "late_min": lateMin,
  };
}
