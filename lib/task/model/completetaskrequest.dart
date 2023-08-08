// To parse this JSON data, do
//
//     final completeTaskRequest = completeTaskRequestFromJson(jsonString);

import 'dart:convert';

List<CompleteTaskRequest> completeTaskRequestFromJson(String str) => List<CompleteTaskRequest>.from(json.decode(str).map((x) => CompleteTaskRequest.fromJson(x)));

String completeTaskRequestToJson(List<CompleteTaskRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompleteTaskRequest {
  String dno;
  String srno;
  String checker;
  String remark;

  CompleteTaskRequest({
    required this.dno,
    required this.srno,
    required this.checker,
    required this.remark,
  });

  factory CompleteTaskRequest.fromJson(Map<String, dynamic> json) => CompleteTaskRequest(
    dno: json["dno"],
    srno: json["srno"],
    checker: json["checker"],
    remark: json["remark"],
  );

  Map<String, dynamic> toJson() => {
    "dno": dno,
    "srno": srno,
    "checker": checker,
    "remark": remark,
  };
}
