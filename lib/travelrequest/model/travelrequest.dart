// To parse this JSON data, do
//
//     final travelRequest = travelRequestFromJson(jsonString);

import 'dart:convert';

List<TravelRequest> travelRequestFromJson(String str) => List<TravelRequest>.from(json.decode(str).map((x) => TravelRequest.fromJson(x)));

String travelRequestToJson(List<TravelRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TravelRequest {
  String pernr;
  String bookingType;
  String empName;
  String fromCountry;
  String fromDistr;
  String fromState;
  String toCountry;
  String toDistr;
  String toState;
  String suggested;
  String travelFrom;
  String travelTo;
  String departSlot;
  String travelDateFrom;
  String travelDateTo;

  TravelRequest({
    required this.pernr,
    required this.bookingType,
    required this.empName,
    required this.fromCountry,
    required this.fromDistr,
    required this.fromState,
    required this.toCountry,
    required this.toDistr,
    required this.toState,
    required this.suggested,
    required this.travelFrom,
    required this.travelTo,
    required this.departSlot,
    required this.travelDateFrom,
    required this.travelDateTo,
  });

  factory TravelRequest.fromJson(Map<String, dynamic> json) => TravelRequest(
    pernr: json["pernr"],
    bookingType: json["booking_type"],
    empName: json["emp_name"],
    fromCountry: json["from_country"],
    fromDistr: json["from_distr"],
    fromState: json["from_state"],
    toCountry: json["to_country"],
    toDistr: json["to_distr"],
    toState: json["to_state"],
    suggested: json["suggested "],
    travelFrom: json["travel_from"],
    travelTo: json["travel_to"],
    departSlot: json["depart_slot"],
    travelDateFrom: json["travel_date_from"],
    travelDateTo: json["travel_date_to"],
  );

  Map<String, dynamic> toJson() => {
    "pernr": pernr,
    "booking_type": bookingType,
    "emp_name": empName,
    "from_country": fromCountry,
    "from_distr": fromDistr,
    "from_state": fromState,
    "to_country": toCountry,
    "to_distr": toDistr,
    "to_state": toState,
    "suggested ": suggested,
    "travel_from": travelFrom,
    "travel_to": travelTo,
    "depart_slot": departSlot,
    "travel_date_from": travelDateFrom,
    "travel_date_to": travelDateTo,
  };

  @override
  String toString() {
    return 'TravelRequest{pernr: $pernr, bookingType: $bookingType, empName: $empName, fromCountry: $fromCountry, fromDistr: $fromDistr, fromState: $fromState, toCountry: $toCountry, toDistr: $toDistr, toState: $toState, suggested: $suggested, travelFrom: $travelFrom, travelTo: $travelTo, departSlot: $departSlot, travelDateFrom: $travelDateFrom, travelDateTo: $travelDateTo}';
  }
}
