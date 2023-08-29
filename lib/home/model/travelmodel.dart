// To parse this JSON data, do
//
//     final travelModel = travelModelFromJson(jsonString);

import 'dart:convert';

List<TravelModel> travelModelFromJson(String str) => List<TravelModel>.from(json.decode(str).map((x) => TravelModel.fromJson(x)));

String travelModelToJson(List<TravelModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TravelModel {
  String pernr;
  String begda;
  String endda;
  String startTime;
  String endTime;
  String startLat;
  String endLat;
  String startLong;
  String endLong;
  String latLong111;
  String startLocation;
  String endLocation;
  String distance;
  String travelMode;
  String latLong;


  TravelModel({
    required this.pernr,
    required this.begda,
    required this.endda,
    required this.startTime,
    required this.endTime,
    required this.startLat,
    required this.endLat,
    required this.startLong,
    required this.endLong,
    required this.latLong111,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.travelMode,
    required this.latLong,

  });

  factory TravelModel.fromJson(Map<String, dynamic> json) => TravelModel(
    pernr: json["pernr"],
    begda: json["begda"],
    endda: json["endda"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    startLat: json["start_lat"],
    endLat: json["end_lat"],
    startLong: json["start_long"],
    endLong: json["end_long"],
    latLong111: json["lat_long111"],
    startLocation: json["start_location"],
    endLocation: json["end_location"],
    distance: json["distance"],
    travelMode: json["TRAVEL_MODE"],
    latLong: json["LAT_LONG"]

  );

  Map<String, dynamic> toJson() => {
    "pernr": pernr,
    "begda": begda,
    "endda": endda,
    "start_time": startTime,
    "end_time": endTime,
    "start_lat": startLat,
    "end_lat": endLat,
    "start_long": startLong,
    "end_long": endLong,
    "lat_long111": latLong111,
    "start_location": startLocation,
    "end_location": endLocation,
    "distance": distance,
    "TRAVEL_MODE": travelMode,
    "LAT_LONG": latLong

  };
}
