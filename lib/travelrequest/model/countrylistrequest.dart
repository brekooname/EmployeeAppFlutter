// To parse this JSON data, do
//
//     final countryListResponse = countryListResponseFromJson(jsonString);

import 'dart:convert';

CountryListResponse countryListResponseFromJson(String str) => CountryListResponse.fromJson(json.decode(str));

String countryListResponseToJson(CountryListResponse data) => json.encode(data.toJson());

class CountryListResponse {
  String status;
  String message;
  List<Response> response;

  CountryListResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CountryListResponse.fromJson(Map<String, dynamic> json) => CountryListResponse(
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
  String land1;
  String landx50;

  Response({
    required this.land1,
    required this.landx50,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    land1: json["land1"],
    landx50: json["landx50"],
  );

  Map<String, dynamic> toJson() => {
    "land1": land1,
    "landx50": landx50,
  };
}
