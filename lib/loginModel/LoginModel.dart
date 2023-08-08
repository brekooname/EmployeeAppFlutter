// To parse this JSON data, do
//
//     final loginModelResponse = loginModelResponseFromJson(jsonString);

import 'dart:convert';

List<LoginModelResponse> loginModelResponseFromJson(String str) => List<LoginModelResponse>.from(json.decode(str).map((x) => LoginModelResponse.fromJson(x)));

String loginModelResponseToJson(List<LoginModelResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginModelResponse {
  String objs;
  String persno;
  String pass;
  String name;
  String mobAtnd;
  String travel;
  String hod;

  LoginModelResponse({
    required this.objs,
    required this.persno,
    required this.pass,
    required this.name,
    required this.mobAtnd,
    required this.travel,
    required this.hod,
  });

  factory LoginModelResponse.fromJson(Map<String, dynamic> json) => LoginModelResponse(
    objs: json["objs"],
    persno: json["persno"],
    pass: json["pass"],
    name: json["name"],
    mobAtnd: json["mobAtnd"],
    travel: json["travel"],
    hod: json["hod"],
  );

  Map<String, dynamic> toJson() => {
    "objs": objs,
    "persno": persno,
    "pass": pass,
    "name": name,
    "mobAtnd": mobAtnd,
    "travel": travel,
    "hod": hod,
  };

  @override
  String toString() {
    return 'LoginModelResponse{objs: $objs, persno: $persno, pass: $pass, name: $name, mobAtnd: $mobAtnd, travel: $travel, hod: $hod}';
  }
}
