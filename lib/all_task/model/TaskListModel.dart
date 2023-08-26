// To parse this JSON data, do
//
//     final taskListModel = taskListModelFromJson(jsonString);

import 'dart:convert';

TaskListModel taskListModelFromJson(String str) => TaskListModel.fromJson(json.decode(str));

String taskListModelToJson(TaskListModel data) => json.encode(data.toJson());

class TaskListModel {
  String status;
  String message;
  List<Response> response;

  TaskListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
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
  String mandt;
  String srno;
  String dno;
  String depName;
  String mrct;
  String agenda;
  String agenda1;
  String discPoint;
  String comDateFrom;
  String comDateTo;
  String resPersonId;
  String rpn;
  String cpid;
  String cpn;
  String cdate;
  String status;

  Response({
    required this.mandt,
    required this.srno,
    required this.dno,
    required this.depName,
    required this.mrct,
    required this.agenda,
    required this.agenda1,
    required this.discPoint,
    required this.comDateFrom,
    required this.comDateTo,
    required this.resPersonId,
    required this.rpn,
    required this.cpid,
    required this.cpn,
    required this.cdate,
    required this.status,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    mandt: json["mandt"],
    srno: json["srno"],
    dno: json["dno"],
    depName: json["dep_name"],
    mrct: json["mrct"],
    agenda: json["agenda"],
    agenda1: json["agenda1"],
    discPoint: json["disc_point"],
    comDateFrom: json["com_date_from"],

    comDateTo: json["com_date_to"],

    resPersonId: json["res_person_id"],
    rpn: json["rpn"],
    cpid: json["cpid"],
    cpn: json["cpn"],
    cdate: json["cdate"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "mandt": mandt,
    "srno": srno,
    "dno": dno,
    "dep_name": depName,
    "mrct": mrct,
    "agenda": agenda,
    "agenda1": agenda1,
    "disc_point": discPoint,
    "com_date_from": comDateFrom,
    "com_date_to": comDateTo,
    "res_person_id": resPersonId,
    "rpn": rpn,
    "cpid": cpid,
    "cpn": cpn,
    "cdate": cdate,
    "status": status,
  };
}
