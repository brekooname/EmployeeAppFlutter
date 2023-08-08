// To parse this JSON data, do
//
//     final taskRespons = taskResponsFromJson(jsonString);

import 'dart:convert';

TaskRespons taskResponsFromJson(String str) => TaskRespons.fromJson(json.decode(str));

String taskResponsToJson(TaskRespons data) => json.encode(data.toJson());

class TaskRespons {
  List<DataSuccess> dataSuccess;

  TaskRespons({
    required this.dataSuccess,
  });

  factory TaskRespons.fromJson(Map<String, dynamic> json) => TaskRespons(
    dataSuccess: List<DataSuccess>.from(json["data_success"].map((x) => DataSuccess.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data_success": List<dynamic>.from(dataSuccess.map((x) => x.toJson())),
  };
}

class DataSuccess {
  String syncData;
  String value;

  DataSuccess({
    required this.syncData,
    required this.value,
  });

  factory DataSuccess.fromJson(Map<String, dynamic> json) => DataSuccess(
    syncData: json["sync_data"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "sync_data": syncData,
    "value": value,
  };
}
