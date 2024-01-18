// To parse this JSON data, do
//
//     final dropListModel = dropListModelFromJson(jsonString);

import 'dart:convert';

DropListModel dropListModelFromJson(String str) => DropListModel.fromJson(json.decode(str));

String dropListModelToJson(DropListModel data) => json.encode(data.toJson());

class DropListModel {
  List<TaxCode> taxCode;
  List<ExpenseType> expenseType;
  List<CostCenter> costCenter;

  DropListModel({
    required this.taxCode,
    required this.expenseType,
    required this.costCenter,
  });

  factory DropListModel.fromJson(Map<String, dynamic> json) => DropListModel(
    taxCode: List<TaxCode>.from(json["Tax_code"].map((x) => TaxCode.fromJson(x))),
    expenseType: List<ExpenseType>.from(json["expense_type"].map((x) => ExpenseType.fromJson(x))),
    costCenter: List<CostCenter>.from(json["cost_center"].map((x) => CostCenter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Tax_code": List<dynamic>.from(taxCode.map((x) => x.toJson())),
    "expense_type": List<dynamic>.from(expenseType.map((x) => x.toJson())),
    "cost_center": List<dynamic>.from(costCenter.map((x) => x.toJson())),
  };
}

class CostCenter {
  String kostl;
  String kostlTxt;
  String ktext;
  String ltext;
  String mctxt;
  String select;

  CostCenter({
    required this.kostl,
    required this.kostlTxt,
    required this.ktext,
    required this.ltext,
    required this.mctxt,
    required this.select,
  });

  factory CostCenter.fromJson(Map<String, dynamic> json) => CostCenter(
    kostl: json["kostl"],
    kostlTxt: json["kostl_txt"],
    ktext: json["ktext"],
    ltext: json["ltext"],
    mctxt: json["mctxt"],
    select: json["select"],
  );

  Map<String, dynamic> toJson() => {
    "kostl": kostl,
    "kostl_txt": kostlTxt,
    "ktext": ktext,
    "ltext": ltext,
    "mctxt": mctxt,
    "select": select,
  };
}

class ExpenseType {
  String mandt;
  String morei;
  String spkzl;
  String endda;
  String spras;
  String begda;
  String paush;
  String pr04O;
  String nbkkl;
  String usefl;
  String sptxt;
  String estC;
  String rndr;

  ExpenseType({
    required this.mandt,
    required this.morei,
    required this.spkzl,
    required this.endda,
    required this.spras,
    required this.begda,
    required this.paush,
    required this.pr04O,
    required this.nbkkl,
    required this.usefl,
    required this.sptxt,
    required this.estC,
    required this.rndr,
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) => ExpenseType(
    mandt: json["mandt"],
    morei:  json["morei"] ,
    spkzl: json["spkzl"],
    endda: json["endda"] ,
    spras:  json["spras"] ,
    begda:  json["begda"] ,
    paush: json["paush"],
    pr04O: json["pr04o"],
    nbkkl: json["nbkkl"],
    usefl: json["usefl"],
    sptxt: json["sptxt"],
    estC: json["est_c"],
    rndr: json["rndr"],
  );

  Map<String, dynamic> toJson() => {
    "mandt": mandt,
    "morei": morei ,
    "spkzl": spkzl,
    "endda": endda ,
    "spras": spras ,
    "begda": begda,
    "paush": paush,
    "pr04o": pr04O,
    "nbkkl": nbkkl,
    "usefl": usefl,
    "sptxt": sptxt,
    "est_c": estC,
    "rndr": rndr,
  };
}



class TaxCode {
  String mandt;
  String taxCode;
  String text;

  TaxCode({
    required this.mandt,
    required this.taxCode,
    required this.text,
  });

  factory TaxCode.fromJson(Map<String, dynamic> json) => TaxCode(
    mandt: json["mandt"],
    taxCode: json["tax_code"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "mandt": mandt,
    "tax_code": taxCode,
    "text": text,
  };
}


