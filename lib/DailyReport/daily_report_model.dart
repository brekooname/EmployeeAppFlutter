import 'dart:convert';

List<DailyReportModel> travelModelFromJson(String str) =>
    List<DailyReportModel>.from(
        json.decode(str).map((x) => DailyReportModel.fromJson(x)));

String travelModelToJson(List<DailyReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyReportModel {
  String pros_vendor;
  String vendor;
  String name;
  String addres;
  String TELF2;
  String VISIT_AT;
  String pernr1;
  String pernr2;
  String pernr3;
  String ACTIVITY;
  String DISC;
  String TGTDATE;
  String STATUS;
  String STREET;
  String REGION;
  String CITY1;
  String CONTACT_P;
  String GATEPASS_NO;
  String photo1;
  String photo2;
  String photo3;
  String photo4;
  String photo5;

  DailyReportModel({
    required this.pros_vendor,
    required this.vendor,
    required this.name,
    required this.addres,
    required this.TELF2,
    required this.VISIT_AT,
    required this.pernr1,
    required this.pernr2,
    required this.pernr3,
    required this.ACTIVITY,
    required this.DISC,
    required this.TGTDATE,
    required this.STATUS,
    required this.STREET,
    required this.REGION,
    required this.CITY1,
    required this.CONTACT_P,
    required this.GATEPASS_NO,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.photo5,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) =>
      DailyReportModel(
        pros_vendor: json["pros_vendor"],
        vendor: json["vendor"],
        name: json["name"],
        addres: json["addres"],
        TELF2: json["TELF2"],
        VISIT_AT: json["VISIT_AT"],
        pernr1: json["pernr1"],
        pernr2: json["pernr2"],
        pernr3: json["pernr3"],
        ACTIVITY: json["ACTIVITY"],
        DISC: json["DISC"],
        TGTDATE: json["TGTDATE"],
        STATUS: json["STATUS"],
        STREET: json["STREET"],
        REGION: json["REGION"],
        CITY1: json["CITY1"],
        CONTACT_P: json["CONTACT_P"],
        GATEPASS_NO: json["GATEPASS_NO"],
        photo1: json["photo1"],
        photo2: json["photo2"],
        photo3: json["photo3"],
        photo4: json["photo4"],
        photo5: json["photo5"],
      );

  Map<String, dynamic> toJson() => {
        "pros_vendor": pros_vendor,
        "vendor": vendor,
        "name": name,
        "addres": addres,
        "TELF2": TELF2,
        "VISIT_AT": VISIT_AT,
        "pernr1": pernr1,
        "pernr2": pernr2,
        "pernr3": pernr3,
        "ACTIVITY": ACTIVITY,
        "DISC": DISC,
        "TGTDATE": TGTDATE,
        "STATUS": STATUS,
        "STREET": STREET,
        "REGION": REGION,
        "CITY1": CITY1,
        "CONTACT_P": CONTACT_P,
        "GATEPASS_NO": GATEPASS_NO,
        "photo1": photo1,
        "photo2": photo2,
        "photo3": photo3,
        "photo4": photo4,
        "photo5": photo5,
      };
}
