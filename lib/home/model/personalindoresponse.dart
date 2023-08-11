// To parse this JSON data, do
//
//     final personalInfoResponse = personalInfoResponseFromJson(jsonString);

import 'dart:convert';

PersonalInfoResponse personalInfoResponseFromJson(String str) => PersonalInfoResponse.fromJson(json.decode(str));

String personalInfoResponseToJson(PersonalInfoResponse data) => json.encode(data.toJson());

class PersonalInfoResponse {
  List<Emp> emp;

  PersonalInfoResponse({
    required this.emp,
  });

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) => PersonalInfoResponse(
    emp: List<Emp>.from(json["emp"].map((x) => Emp.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "emp": List<dynamic>.from(emp.map((x) => x.toJson())),
  };
}

class Emp {
  String pernr;
  String bukrs;
  String werks;
  String persk;
  String btrtl;
  String btrtlTxt;
  String perskTxt;
  String telnr;
  String emailShkt;
  String emailPers;
  String hod;
  String hodEname;
  String stras;
  String locat;
  String address;
  String gender;
  String birth;
  String birth1;
  String marital;
  String bankn;
  String bankl;
  String bankTxt;

  Emp({
    required this.pernr,
    required this.bukrs,
    required this.werks,
    required this.persk,
    required this.btrtl,
    required this.btrtlTxt,
    required this.perskTxt,
    required this.telnr,
    required this.emailShkt,
    required this.emailPers,
    required this.hod,
    required this.hodEname,
    required this.stras,
    required this.locat,
    required this.address,
    required this.gender,
    required this.birth,
    required this.birth1,
    required this.marital,
    required this.bankn,
    required this.bankl,
    required this.bankTxt,
  });

  factory Emp.fromJson(Map<String, dynamic> json) => Emp(
    pernr: json["pernr"],
    bukrs: json["bukrs"],
    werks: json["werks"],
    persk: json["persk"],
    btrtl: json["btrtl"],
    btrtlTxt: json["btrtl_txt"],
    perskTxt: json["persk_txt"],
    telnr: json["telnr"],
    emailShkt: json["email_shkt"],
    emailPers: json["email_pers"],
    hod: json["hod"],
    hodEname: json["hod_ename"],
    stras: json["stras"],
    locat: json["locat"],
    address: json["address"],
    gender: json["gender"],
    birth: json["birth"],
    birth1: json["birth1"],
    marital: json["marital"],
    bankn: json["bankn"],
    bankl: json["bankl"],
    bankTxt: json["bank_txt"],
  );

  factory Emp.fromMap(Map<String, dynamic> map) => Emp(
    pernr: map["pernr"],
    bukrs: map["bukrs"],
    werks: map["werks"],
    persk: map["persk"],
    btrtl: map["btrtl"],
    btrtlTxt: map["btrtl_txt"],
    perskTxt: map["persk_txt"],
    telnr: map["telnr"],
    emailShkt: map["email_shkt"],
    emailPers: map["email_pers"],
    hod: map["hod"],
    hodEname: map["hod_ename"],
    stras: map["stras"],
    locat: map["locat"],
    address: map["address"],
    gender: map["gender"],
    birth: map["birth"],
    birth1: map["birth1"],
    marital: map["marital"],
    bankn: map["bankn"],
    bankl: map["bankl"],
    bankTxt: map["bank_txt"],
  );


  Map<String, dynamic> toJson() => {
    "pernr": pernr,
    "bukrs": bukrs,
    "werks": werks,
    "persk": persk,
    "btrtl": btrtl,
    "btrtl_txt": btrtlTxt,
    "persk_txt": perskTxt,
    "telnr": telnr,
    "email_shkt": emailShkt,
    "email_pers": emailPers,
    "hod": hod,
    "hod_ename": hodEname,
    "stras": stras,
    "locat": locat,
    "address": address,
    "gender": gender,
    "birth": birth,
    "birth1": birth1,
    "marital": marital,
    "bankn": bankn,
    "bankl": bankl,
    "bank_txt": bankTxt,
  };

  @override
  String toString() {
    return 'Emp{pernr: $pernr, bukrs: $bukrs, werks: $werks, persk: $persk, btrtl: $btrtl, btrtlTxt: $btrtlTxt, perskTxt: $perskTxt, telnr: $telnr, emailShkt: $emailShkt, emailPers: $emailPers, hod: $hod, hodEname: $hodEname, stras: $stras, locat: $locat, address: $address, gender: $gender, birth: $birth, birth1: $birth1, marital: $marital, bankn: $bankn, bankl: $bankl, bankTxt: $bankTxt}';
  }
}
