// To parse this JSON data, do
//
//     final taskRequest = taskRequestFromJson(jsonString);

import 'dart:convert';

TaskRequest taskRequestFromJson(String str) => TaskRequest.fromJson(json.decode(str));

String taskRequestToJson(TaskRequest data) => json.encode(data.toJson());

class TaskRequest {
  String pernr;
  String budat;
  String time;
  String description;
  String assignTo;
  String dateFrom;
  String dateTo;
  String mrcType;
  String department;

  TaskRequest({
    required this.pernr,
    required this.budat,
    required this.time,
    required this.description,
    required this.assignTo,
    required this.dateFrom,
    required this.dateTo,
    required this.mrcType,
    required this.department,
  });

  factory TaskRequest.fromJson(Map<String, dynamic> json) => TaskRequest(
    pernr: json["pernr"],
    budat: json["budat"],
    time: json["time"],
    description: json["description"],
    assignTo: json["assign_to"],
    dateFrom: json["date_from"],
    dateTo: json["date_to"],
    mrcType: json["mrc_type"],
    department: json["department"],
  );

  Map<String, dynamic> toJson() => {
    "pernr": pernr,
    "budat": budat,
    "time": time,
    "description": description,
    "assign_to": assignTo,
    "date_from": dateFrom,
    "date_to": dateTo,
    "mrc_type": mrcType,
    "department": department,
  };
}
