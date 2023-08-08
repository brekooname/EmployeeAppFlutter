// To parse this JSON data, do
//
//     final vendorNameResponse = vendorNameResponseFromJson(jsonString);

import 'dart:convert';

VendorNameResponse vendorNameResponseFromJson(String str) => VendorNameResponse.fromJson(json.decode(str));

String vendorNameResponseToJson(VendorNameResponse data) => json.encode(data.toJson());

class VendorNameResponse {
  String status;
  String message;
  List<Response> response;

  VendorNameResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory VendorNameResponse.fromJson(Map<String, dynamic> json) => VendorNameResponse(
    status: json["response"]!=null ?json["status"]:"false",
    message: json["response"]!=null ?json["message"]:"",
    response: json["response"]!=null ?List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String lifnr;
  String name1;
  String stras;
  String ort01;
  String ort02;
  String telf1;
  String add;

  Response({
    required this.lifnr,
    required this.name1,
    required this.stras,
    required this.ort01,
    required this.ort02,
    required this.telf1,
    required this.add,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    lifnr: json["lifnr"]!=null?json["lifnr"]:"",
    name1: json["name1"]!=null?json["name1"]:"",
    stras: json["stras"]!=null?json["stras"]:"",
    ort01: json["ort01"]!=null?json["ort01"]:"",
    ort02: json["ort02"]!=null?json["ort02"]:"",
    telf1: json["telf1"]!=null?json["telf1"]:"",
    add: json["add"]!=null?json["add"]:"",
  );

  Map<String, dynamic> toJson() => {
    "lifnr": lifnr,
    "name1": name1,
    "stras": stras,
    "ort01": ort01,
    "ort02": ort02,
    "telf1": telf1,
    "add": add,
  };
}
