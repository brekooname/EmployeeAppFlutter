import 'dart:convert';

List<ShiftDataRequestModel> shiftDataRequestModelFromJson(String str) => List<ShiftDataRequestModel>.from(json.decode(str).map((x) => ShiftDataRequestModel.fromJson(x)));

String shiftDataRequestModelToJson(List<ShiftDataRequestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftDataRequestModel {
  String docno;
  String hod;
  String pernr;
  String begda;
  String shift;
  String shftInnTime;
  String shftOutTime;
  String remarkEmp;
  String hodApp;
  String appBy;

  ShiftDataRequestModel({
    required this.docno,
    required this.hod,
    required this.pernr,
    required this.begda,
    required this.shift,
    required this.shftInnTime,
    required this.shftOutTime,
    required this.remarkEmp,
    required this.hodApp,
    required this.appBy,
  });

  factory ShiftDataRequestModel.fromJson(Map<String, dynamic> json) => ShiftDataRequestModel(
    docno: json["DOCNO"],
    hod: json["HOD"],
    pernr: json["PERNR"],
    begda: json["BEGDA"],
    shift: json["SHIFT"],
    shftInnTime: json["SHFT_INN_TIME"],
    shftOutTime: json["SHFT_OUT_TIME"],
    remarkEmp: json["REMARK_EMP"],
    hodApp: json["HOD_APP"],
    appBy: json["APP_BY"],
  );

  Map<String, dynamic> toJson() => {
    "DOCNO": docno,
    "HOD": hod,
    "PERNR": pernr,
    "BEGDA": begda,
    "SHIFT": shift,
    "SHFT_INN_TIME": shftInnTime,
    "SHFT_OUT_TIME": shftOutTime,
    "REMARK_EMP": remarkEmp,
    "HOD_APP": hodApp,
    "APP_BY": appBy,
  };
}
