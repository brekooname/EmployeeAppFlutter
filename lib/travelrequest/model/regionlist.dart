// To parse this JSON data, do
//
//     final regionListResponse = regionListResponseFromJson(jsonString);

import 'dart:convert';

RegionListResponse regionListResponseFromJson(String str) => RegionListResponse.fromJson(json.decode(str));

String regionListResponseToJson(RegionListResponse data) => json.encode(data.toJson());

class RegionListResponse {
  String status;
  String message;
  List<Response> response;

  RegionListResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory RegionListResponse.fromJson(Map<String, dynamic> json) => RegionListResponse(
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
  String tehsil;
  String district;
  String regio;
  String land1;
  String tehsilText;
  String grd;
  String bezei;
  String landx;
  String stBezei;

  Response({
    required this.tehsil,
    required this.district,
    required this.regio,
    required this.land1,
    required this.tehsilText,
    required this.grd,
    required this.bezei,
    required this.landx,
    required this.stBezei,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    tehsil: json["tehsil"],
    district: json["district"],
    regio: json["regio"],
    land1: json["land1"],
    tehsilText: json["tehsil_text"],
    grd: json["grd"],
    bezei: json["bezei"],
    landx: json["landx"],
    stBezei: json["st_bezei"],
  );

  Map<String, dynamic> toJson() => {
    "tehsil": tehsil,
    "district": district,
    "regio": regio,
    "land1": land1,
    "tehsil_text": tehsilText,
    "grd": grd,
    "bezei": bezei,
    "landx": landx,
    "st_bezei": stBezei,
  };
}
