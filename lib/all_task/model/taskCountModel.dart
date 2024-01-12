// To parse this JSON data, do
//
//     final taskCountModel = taskCountModelFromJson(jsonString);

import 'dart:convert';

TaskCountModel taskCountModelFromJson(String str) => TaskCountModel.fromJson(json.decode(str));

String taskCountModelToJson(TaskCountModel data) => json.encode(data.toJson());

class TaskCountModel {
  String status;
  String message;
  List<Completed> pending;
  List<Completed> total;
  List<Completed> completed;

  TaskCountModel({
    required this.status,
    required this.message,
    required this.pending,
    required this.total,
    required this.completed,
  });

  factory TaskCountModel.fromJson(Map<String, dynamic> json) => TaskCountModel(
    status: json["status"],
    message: json["message"],
    pending: json["Pending"] !=null? List<Completed>.from(json["Pending"].map((x) => Completed.fromJson(x))):[],
    total: json["total"] != null? List<Completed>.from(json["total"].map((x) => Completed.fromJson(x))):[],
    completed:["Completed"]!= null? List<Completed>.from(json["Completed"].map((x) => Completed.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Pending": List<dynamic>.from(pending.map((x) => x.toJson())),
    "total": List<dynamic>.from(total.map((x) => x.toJson())),
    "Completed": List<dynamic>.from(completed.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'TaskCountModel{status: $status, message: $message, pending: $pending, total: $total, completed: $completed}';
  }
}

class Completed {
  String pernr;
  String depName;
  String count;

  Completed({
    required this.pernr,
    required this.depName,
    required this.count,
  });

  factory Completed.fromJson(Map<String, dynamic> json) => Completed(
    pernr: json["pernr"],
    depName: json["dep_name"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "pernr": pernr,
    "dep_name": depName,
    "count": count,
  };

  @override
  String toString() {
    return 'Completed{pernr: $pernr, depName: $depName, count: $count}';
  }
}
