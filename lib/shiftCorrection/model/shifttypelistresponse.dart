// To parse this JSON data, do
//
//     final shiftTypeListResponse = shiftTypeListResponseFromJson(jsonString);

import 'dart:convert';

ShiftTypeListResponse shiftTypeListResponseFromJson(String str) => ShiftTypeListResponse.fromJson(json.decode(str));

String shiftTypeListResponseToJson(ShiftTypeListResponse data) => json.encode(data.toJson());

class ShiftTypeListResponse {
  String status;
  String message;
  List<Response> response;

  ShiftTypeListResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory ShiftTypeListResponse.fromJson(Map<String, dynamic> json) => ShiftTypeListResponse(
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
  String shift;
  String startTim;
  String endTim;

  Response({
    required this.shift,
    required this.startTim,
    required this.endTim,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    shift: json["shift"],
    startTim: json["start_tim"],
    endTim: json["end_tim"],
  );

  Map<String, dynamic> toJson() => {
    "shift": shift,
    "start_tim": startTim,
    "end_tim": endTim,
  };
}
