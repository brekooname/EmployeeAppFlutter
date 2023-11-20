// To parse this JSON data, do
//
//     final cityListResponse = cityListResponseFromJson(jsonString);

import 'dart:convert';

CityListResponse cityListResponseFromJson(String str) => CityListResponse.fromJson(json.decode(str));

String cityListResponseToJson(CityListResponse data) => json.encode(data.toJson());

class CityListResponse {
  String status;
  String message;
  List<Response> response;

  CityListResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CityListResponse.fromJson(Map<String, dynamic> json) => CityListResponse(
    status: json["status"],
    message: json["message"],
    response:json["response"] !=null? List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String cityc;
  String bezei;

  Response({
    required this.cityc,
    required this.bezei,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    cityc: json["cityc"],
    bezei: json["bezei"],
  );

  Map<String, dynamic> toJson() => {
    "cityc": cityc,
    "bezei": bezei,
  };
}
