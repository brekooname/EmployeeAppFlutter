// To parse this JSON data, do
//
//     final distanceCalculateModel = distanceCalculateModelFromJson(jsonString);

import 'dart:convert';

DistanceCalculateModel distanceCalculateModelFromJson(String str) => DistanceCalculateModel.fromJson(json.decode(str));

String distanceCalculateModelToJson(DistanceCalculateModel data) => json.encode(data.toJson());

class DistanceCalculateModel {
  List<Route> routes;

  DistanceCalculateModel({
    required this.routes,
  });

  factory DistanceCalculateModel.fromJson(Map<String, dynamic> json) => DistanceCalculateModel(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
  };
}

class Route {
  List<Leg> legs;
  String summary;

  Route({
    required this.legs,
    required this.summary,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
    summary: json["summary"],
  );

  Map<String, dynamic> toJson() => {
    "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
    "summary": summary,
  };
}


class Northeast {
  double lat;
  double lng;

  Northeast({
    required this.lat,
    required this.lng,
  });

  factory Northeast.fromJson(Map<String, dynamic> json) => Northeast(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Leg {
  Distance distance;
  Distance duration;
  String endAddress;
  Northeast endLocation;
  String startAddress;
  Northeast startLocation;

  Leg({
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,

  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    distance: Distance.fromJson(json["distance"]),
    duration: Distance.fromJson(json["duration"]),
    endAddress: json["end_address"],
    endLocation: Northeast.fromJson(json["end_location"]),
    startAddress: json["start_address"],
    startLocation: Northeast.fromJson(json["start_location"]),
    );

  Map<String, dynamic> toJson() => {
    "distance": distance.toJson(),
    "duration": duration.toJson(),
    "end_address": endAddress,
    "end_location": endLocation.toJson(),
    "start_address": startAddress,
    "start_location": startLocation.toJson(),
     };
}

class Distance {
  String text;
  int value;

  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    text: json["text"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}




