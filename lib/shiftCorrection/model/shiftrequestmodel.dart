import 'dart:convert';

List<ShiftRequestModel> shiftRequestModelFromJson(String str) => List<ShiftRequestModel>.from(json.decode(str).map((x) => ShiftRequestModel.fromJson(x)));

String shiftRequestModelToJson(List<ShiftRequestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftRequestModel {
  String pernr;
  String begda;
  String shift;
  String shftInnTime;
  String shftOutTime;
  String remarkEmp;

  ShiftRequestModel({
    required this.pernr,
    required this.begda,
    required this.shift,
    required this.shftInnTime,
    required this.shftOutTime,
    required this.remarkEmp,
  });

  factory ShiftRequestModel.fromJson(Map<String, dynamic> json) => ShiftRequestModel(
    pernr: json["PERNR"],
    begda: json["BEGDA"],
    shift: json["SHIFT"],
    shftInnTime: json["SHFT_INN_TIME"],
    shftOutTime: json["SHFT_OUT_TIME"],
    remarkEmp: json["REMARK_EMP"],
  );

  Map<String, dynamic> toJson() => {
    "PERNR": pernr,
    "BEGDA": begda,
    "SHIFT": shift,
    "SHFT_INN_TIME": shftInnTime,
    "SHFT_OUT_TIME": shftOutTime,
    "REMARK_EMP": remarkEmp,
  };

  @override
  String toString() {
    return '{pernr: $pernr, begda: $begda, shift: $shift, shftInnTime: $shftInnTime, shftOutTime: $shftOutTime, remarkEmp: $remarkEmp}';
  }
}
