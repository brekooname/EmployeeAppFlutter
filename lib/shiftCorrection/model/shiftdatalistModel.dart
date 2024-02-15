// To parse this JSON data, do
//
//     final shiftDataListModel = shiftDataListModelFromJson(jsonString);

import 'dart:convert';

ShiftDataListModel shiftDataListModelFromJson(String str) => ShiftDataListModel.fromJson(json.decode(str));

String shiftDataListModelToJson(ShiftDataListModel data) => json.encode(data.toJson());

class ShiftDataListModel {
  String status;
  String message;
  List<Response> response;

  ShiftDataListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory ShiftDataListModel.fromJson(Map<String, dynamic> json) => ShiftDataListModel(
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
  String mndt;
  String docno;
  String pernr;
  String begda;
  String shift;
  String shftInnTime;
  String shftOutTime;
  String crtDat;
  String crtTims;
  String remarkEmp;
  String remarkHod;
  String hod;
  String hodApp;
  String hrApp;
  String hrRemark;
  String hodDats;
  String hrDats;

  Response({
    required this.ename,
    required this.mndt,
    required this.docno,
    required this.pernr,
    required this.begda,
    required this.shift,
    required this.shftInnTime,
    required this.shftOutTime,
    required this.crtDat,
    required this.crtTims,
    required this.remarkEmp,
    required this.remarkHod,
    required this.hod,
    required this.hodApp,
    required this.hrApp,
    required this.hrRemark,
    required this.hodDats,
    required this.hrDats,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    ename: json["ename"],
    mndt: json["mndt"],
    docno: json["docno"],
    pernr: json["pernr"],
    begda: json["begda"],
    shift: json["shift"],
    shftInnTime: json["shft_inn_time"],
    shftOutTime: json["shft_out_time"],
    crtDat: json["crt_dat"],
    crtTims: json["crt_tims"],
    remarkEmp: json["remark_emp"],
    remarkHod: json["remark_hod"],
    hod: json["hod"],
    hodApp: json["hod_app"],
    hrApp: json["hr_app"],
    hrRemark: json["hr_remark"],
    hodDats: json["hod_dats"],
    hrDats: json["hr_dats"],
  );

  Map<String, dynamic> toJson() => {
    "ename": ename,
    "mndt": mndt,
    "docno": docno,
    "pernr": pernr,
    "begda": begda,
    "shift": shift,
    "shft_inn_time": shftInnTime,
    "shft_out_time": shftOutTime,
    "crt_dat": crtDat,
    "crt_tims": crtTims,
    "remark_emp": remarkEmp,
    "remark_hod": remarkHod,
    "hod": hod,
    "hod_app": hodApp,
    "hr_app": hrApp,
    "hr_remark": hrRemark,
    "hod_dats": hodDats,
    "hr_dats": hrDats,
  };
}
