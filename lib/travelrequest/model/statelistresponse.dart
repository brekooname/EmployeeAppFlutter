// To parse this JSON data, do
//
//     final stateListResponse = stateListResponseFromJson(jsonString);

import 'dart:convert';

StateListResponse stateListResponseFromJson(String str) => StateListResponse.fromJson(json.decode(str));

String stateListResponseToJson(StateListResponse data) => json.encode(data.toJson());

class StateListResponse {
  String status;
  String message;
  List<Response> response;

  StateListResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory StateListResponse.fromJson(Map<String, dynamic> json) => StateListResponse(
    status: json["status"],
    message: json["message"],
    response: json["response"] != null?List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'StateListResponse{status: $status, message: $message, response: $response}';
  }
}

class Response {
  String bland;
  String bezei;

  Response({
    required this.bland,
    required this.bezei,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    bland: json["bland"],
    bezei: json["bezei"],
  );

  Map<String, dynamic> toJson() => {
    "bland": bland,
    "bezei": bezei,
  };

}
