class LocalConveyanceModel {
  int empId;
  String userId,fromLatitude,
      fromLongitude,
      toLatitude,
      toLongitude,
      fromAddress,
      toAddress,
      createDate,
      createTime,
      endDate,
      endTime;

  LocalConveyanceModel(
      {required this.empId,
        required this.userId,
      required this.fromLatitude,
      required this.fromLongitude,
      required this.toLatitude,
      required this.toLongitude,
      required this.fromAddress,
      required this.toAddress,
      required this.createDate,
      required this.createTime,
      required this.endDate,
      required this.endTime});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["from_latitude"] = fromLatitude;
    map["from_longitude"] = fromLongitude;
    map["to_latitude"] = toLatitude;
    map["to_longitude"] = toLongitude;
    map["from_address"] = fromAddress;
    map["to_address"] = toAddress;
    map["create_date"] = createDate;
    map["create_time"] = createTime;
    map["end_date"] = endDate;
    map["end_time"] = endTime;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["emp_id"] = empId;
    map["user_id"] = userId;
    map["from_latitude"] = fromLatitude;
    map["from_longitude"] = fromLongitude;
    map["to_latitude"] = toLatitude;
    map["to_longitude"] = toLongitude;
    map["from_address"] = fromAddress;
    map["to_address"] = toAddress;
    map["create_date"] = createDate;
    map["create_time"] = createTime;
    map["end_date"] = endDate;
    map["end_time"] = endTime;
    return map;
  }

  //to be used when converting the row into object
  factory LocalConveyanceModel.fromMap(Map<String, dynamic> data) =>
      LocalConveyanceModel(
        empId: data['emp_id'] ?? 0,
        userId: data['user_id'] ?? "",
        fromLatitude: data['from_latitude'] ?? "",
        fromLongitude: data['from_longitude'] ?? "",
        toLatitude: data['to_latitude'] ?? "",
        toLongitude: data['to_longitude'] ?? "",
        fromAddress: data['from_address'] ?? "",
        toAddress: data['to_address'] ?? "",
        createDate: data['create_date'] ?? "",
        createTime: data['create_time'] ?? "",
        endDate: data['end_date'] ?? "",
        endTime: data['end_time'] ?? "",
      );
}
