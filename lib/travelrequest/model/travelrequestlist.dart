// To parse this JSON data, do
//
//     final travelRequestList = travelRequestListFromJson(jsonString);

import 'dart:convert';

TravelRequestList travelRequestListFromJson(String str) => TravelRequestList.fromJson(json.decode(str));

String travelRequestListToJson(TravelRequestList data) => json.encode(data.toJson());

class TravelRequestList {
  String status;
  String message;
  List<Response> response;

  TravelRequestList({
    required this.status,
    required this.message,
    required this.response,
  });

  factory TravelRequestList.fromJson(Map<String, dynamic> json) => TravelRequestList(
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
  String bookingType;
  String empName;
  String fromCountry;
  String fromDistr;
  String fromState;
  String toCountry;
  String toDistr;
  String toState;
  String hodPernr;
  String pernr;
  String suggested;
  String travelFrom;
  String travelTo;
  String departSlot;
  String travelDateFrom;
  String travelDateTo;
  String status;

  Response({
    required this.docno,
    required this.bookingType,
    required this.empName,
    required this.fromCountry,
    required this.fromDistr,
    required this.fromState,
    required this.toCountry,
    required this.toDistr,
    required this.toState,
    required this.hodPernr,
    required this.pernr,
    required this.suggested,
    required this.travelFrom,
    required this.travelTo,
    required this.departSlot,
    required this.travelDateFrom,
    required this.travelDateTo,
    required this.status,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    docno: json["docno"],
    bookingType: json["booking_type"],
    empName: json["emp_name"],
    fromCountry: json["from_country"],
    fromDistr: json["from_distr"],
    fromState: json["from_state"],
    toCountry: json["to_country"],
    toDistr: json["to_distr"],
    toState: json["to_state"],
    hodPernr: json["hod_pernr"],
    pernr: json["pernr"],
    suggested: json["suggested"],
    travelFrom: json["travel_from"],
    travelTo: json["travel_to"],
    departSlot: json["depart_slot"],
    travelDateFrom: json["travel_date_from"],
    travelDateTo: json["travel_date_to"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "docno": docno,
    "booking_type": bookingType,
    "emp_name": empName,
    "from_country": fromCountry,
    "from_distr": fromDistr,
    "from_state": fromState,
    "to_country": toCountry,
    "to_distr": toDistr,
    "to_state": toState,
    "hod_pernr": hodPernr,
    "pernr": pernr,
    "suggested": suggested,
    "travel_from": travelFrom,
    "travel_to": travelTo,
    "depart_slot": departSlot,
    "travel_date_from": travelDateFrom,
    "travel_date_to": travelDateTo,
    "status": status,
  };
}
