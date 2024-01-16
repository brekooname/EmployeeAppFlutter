// To parse this JSON data, do
//
//     final saveTravelExpenseResponse = saveTravelExpenseResponseFromJson(jsonString);

import 'dart:convert';

SaveTravelExpenseResponse saveTravelExpenseResponseFromJson(String str) => SaveTravelExpenseResponse.fromJson(json.decode(str));

String saveTravelExpenseResponseToJson(SaveTravelExpenseResponse data) => json.encode(data.toJson());

class SaveTravelExpenseResponse {
  String status;
  String message;
  List<Response> response;

  SaveTravelExpenseResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory SaveTravelExpenseResponse.fromJson(Map<String, dynamic> json) => SaveTravelExpenseResponse(
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
  String cmpno;
  String responseReturn;

  Response({
    required this.cmpno,
    required this.responseReturn,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    cmpno: json["cmpno"],
    responseReturn: json["return"],
  );

  Map<String, dynamic> toJson() => {
    "cmpno": cmpno,
    "return": responseReturn,
  };
}
