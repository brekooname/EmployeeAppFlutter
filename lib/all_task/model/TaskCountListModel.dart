// To parse this JSON data, do
//
//     final TaskCountListModel = taskListModelFromJson(jsonString);

import 'dart:convert';

TaskCountListModel taskListModelFromJson(String str) => TaskCountListModel.fromJson(json.decode(str));

String taskListModelToJson(TaskCountListModel data) => json.encode(data.toJson());

class TaskCountListModel {
  List<TaskCountList> taskList;

  TaskCountListModel({
    required this.taskList,
  });

  factory TaskCountListModel.fromJson(Map<String, dynamic> json) => TaskCountListModel(
    taskList: List<TaskCountList>.from(json["TaskList"].map((x) => TaskCountList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "TaskList": List<dynamic>.from(taskList.map((x) => x.toJson())),
  };
}

class TaskCountList {
  String pernr;
  String depName;
  String pendingTaskCount;
  String totalTaskCount;
  String completedTaskCount;

  TaskCountList({
    required this.pernr,
    required this.depName,
    required this.pendingTaskCount,
    required this.totalTaskCount,
    required this.completedTaskCount,
  });

  factory TaskCountList.fromJson(Map<String, dynamic> json) => TaskCountList(
    pernr: json["pernr"],
    depName: json["dep_name"],
    pendingTaskCount: json["pending_task_count"],
    totalTaskCount: json["total_task_count"],
    completedTaskCount: json["completed_task_count"],
  );

  Map<String, dynamic> toJson() => {
    "pernr": pernr,
    "dep_name": depName,
    "pending_task_count": pendingTaskCount,
    "total_task_count": totalTaskCount,
    "completed_task_count": completedTaskCount,
  };
}
