// To parse this JSON data, do
//
//     final distanceCalculateModel = distanceCalculateModelFromJson(jsonString);

import 'dart:convert';

DistanceCalculateModel distanceCalculateModelFromJson(String str) => DistanceCalculateModel.fromJson(json.decode(str));

String distanceCalculateModelToJson(DistanceCalculateModel data) => json.encode(data.toJson());

class DistanceCalculateModel {
  List<String> destinationAddresses;
  List<String> originAddresses;
  List<Row> rows;
  String status;

  DistanceCalculateModel({
    required this.destinationAddresses,
    required this.originAddresses,
    required this.rows,
    required this.status,
  });

  factory DistanceCalculateModel.fromJson(Map<String, dynamic> json) => DistanceCalculateModel(
    destinationAddresses: List<String>.from(json["destination_addresses"].map((x) => x)),
    originAddresses: List<String>.from(json["origin_addresses"].map((x) => x)),
    rows: List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "destination_addresses": List<dynamic>.from(destinationAddresses.map((x) => x)),
    "origin_addresses": List<dynamic>.from(originAddresses.map((x) => x)),
    "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
    "status": status,
  };
}

class Row {
  List<Element> elements;

  Row({
    required this.elements,
  });

  factory Row.fromJson(Map<String, dynamic> json) => Row(
    elements: List<Element>.from(json["elements"].map((x) => Element.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
  };
}

class Element {
  Distance distance;
  Distance duration;
  String status;

  Element({
    required this.distance,
    required this.duration,
    required this.status,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
    distance: Distance.fromJson(json["distance"]),
    duration: Distance.fromJson(json["duration"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "distance": distance.toJson(),
    "duration": duration.toJson(),
    "status": status,
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
