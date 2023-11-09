// To parse this JSON data, do
//
//     final travelListResponse = travelListResponseFromJson(jsonString);

import 'dart:convert';

TravelListResponse travelListResponseFromJson(String str) => TravelListResponse.fromJson(json.decode(str));

String travelListResponseToJson(TravelListResponse data) => json.encode(data.toJson());

class TravelListResponse {
  String status;
  String message;
  List<Response> response;

  TravelListResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory TravelListResponse.fromJson(Map<String, dynamic> json) => TravelListResponse(
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
  String docno;
  String pernr;
  String btrtl;
  String bookingType;
  String departSlot;
  String hodPernr;
  String travelDateFrom;
  String travelDateTo;
  String suggested;
  String empName;
  String fromCountry;
  String fromDistr;
  String fromState;
  String travelFrom;
  String toDistr;
  String toState;
  String toCountry;
  String travelTo;
  String createdDate;
  String createdTime;
  String createdIp;
  String hodAppDate;
  String hodApp;
  String hodAppTime;
  String status;

  Response({
    required this.docno,
    required this.pernr,
    required this.btrtl,
    required this.bookingType,
    required this.departSlot,
    required this.hodPernr,
    required this.travelDateFrom,
    required this.travelDateTo,
    required this.suggested,
    required this.empName,
    required this.fromCountry,
    required this.fromDistr,
    required this.fromState,
    required this.travelFrom,
    required this.toDistr,
    required this.toState,
    required this.toCountry,
    required this.travelTo,
    required this.createdDate,
    required this.createdTime,
    required this.createdIp,
    required this.hodAppDate,
    required this.hodApp,
    required this.hodAppTime,
    required this.status,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    docno: json["docno"],
    pernr: json["pernr"],
    btrtl: json["btrtl"],
    bookingType: json["booking_type"],
    departSlot: json["depart_slot"],
    hodPernr: json["hod_pernr"],
    travelDateFrom: json["travel_date_from"],
    travelDateTo: json["travel_date_to"],
    suggested: json["suggested"],
    empName: json["emp_name"],
    fromCountry: json["from_country"],
    fromDistr: json["from_distr"],
    fromState: json["from_state"],
    travelFrom: json["travel_from"],
    toDistr: json["to_distr"],
    toState: json["to_state"],
    toCountry: json["to_country"],
    travelTo: json["travel_to"],
    createdDate: json["created_date"],
    createdTime: json["created_time"],
    createdIp: json["created_ip"],
    hodAppDate: json["hod_app_date"],
    hodApp: json["hod_app"],
    hodAppTime: json["hod_app_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "docno": docno,
    "pernr": pernr,
    "btrtl": btrtl,
    "booking_type": bookingType,
    "depart_slot": departSlot,
    "hod_pernr": hodPernr,
    "travel_date_from": travelDateFrom,
    "travel_date_to": travelDateTo,
    "suggested": suggested,
    "emp_name": empName,
    "from_country": fromCountry,
    "from_distr": fromDistr,
    "from_state": fromState,
    "travel_from": travelFrom,
    "to_distr": toDistr,
    "to_state": toState,
    "to_country": toCountry,
    "travel_to": travelTo,
    "created_date": createdDate,
    "created_time": createdTime,
    "created_ip": createdIp,
    "hod_app_date": hodAppDate,
    "hod_app": hodApp,
    "hod_app_time": hodAppTime,
    "status": status,
  };
}
