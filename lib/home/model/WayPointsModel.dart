class WayPointsModel{
  String userId,latlng,
      createDate,
      createTime,
      endDate,
      endTime;

  WayPointsModel(
      {required this.userId,
        required this.latlng,
        required this.createDate,
        required this.createTime,
        required this.endDate,
        required this.endTime});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["lat_lng"] = latlng;
    map["create_date"] = createDate;
    map["create_time"] = createTime;
    map["end_date"] = endDate;
    map["end_time"] = endTime;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["lat_lng"] = latlng;
    map["create_date"] = createDate;
    map["create_time"] = createTime;
    map["end_date"] = endDate;
    map["end_time"] = endTime;
    return map;
  }

  //to be used when converting the row into object
  factory WayPointsModel.fromMap(Map<String, dynamic> data) =>
      WayPointsModel(
        userId: data['user_id'] ?? "",
        latlng: data['lat_lng'] ?? "",
        createDate: data['create_date'] ?? "",
        createTime: data['create_time'] ?? "",
        endDate: data['end_date'] ?? "",
        endTime: data['end_time'] ?? "",
      );
}