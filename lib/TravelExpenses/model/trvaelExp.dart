

class TravelExpenseModel {
  int key;
  String fromDate;
  String toDate;
  String country;
  String state;
  String city;
  String expenseType;
  String taxCode;
  String location;
  String rec_amount;
  String rec_curr;
  String descript;
  String gstNo;
  String region;

  TravelExpenseModel({
    required this.key,
    required this.fromDate,
    required this.toDate,
    required this.country,
    required this.state,
    required this.city,
    required this.expenseType,
    required this.taxCode,
    required this.location,
    required this.rec_amount,
    required this.rec_curr,
    required this.descript,
    required this.gstNo,
    required this.region,
  });

  factory TravelExpenseModel.fromJson(Map<String, dynamic> json) => TravelExpenseModel(
    key: json["column_id"]?? "",
    fromDate: json["from_date1"]?? "",
    toDate: json["to_date1"]?? "",
    country: json["country"]?? "",
    state: json["state"]?? "",
    city: json["city"]?? "",
    expenseType: json["exp_type"]?? "",
    taxCode: json["TAX_CODE"]?? "",
    location: json["location"]?? "",
    rec_amount: json["rec_amount"]?? "",
    rec_curr: json["rec_curr"]?? "",
    descript: json["descript"]?? "",
    gstNo: json["gst_no"]?? "",
    region: json["region"]?? "",
  );


  factory TravelExpenseModel.fromMap(Map<String, dynamic> json) => TravelExpenseModel(
    key: json["column_id"]?? "",
    fromDate: json["from_date1"]?? "",
    toDate: json["to_date1"]?? "",
    country: json["country"]?? "",
    state: json["state"]?? "",
    city: json["city"]?? "",
    expenseType: json["exp_type"]?? "",
    taxCode: json["TAX_CODE"]?? "",
    location: json["location"]?? "",
    rec_amount: json["rec_amount"]?? "",
    rec_curr: json["rec_curr"]?? "",
    descript: json["descript"]?? "",
    gstNo: json["gst_no"]?? "",
    region: json["region"]?? "",
  );

  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["from_date1"] = fromDate;
    map["to_date1"] = toDate;
    map["country"] = country;
    map["state"] = state;
    map["city"] = city;
    map["exp_type"] = expenseType;
    map["TAX_CODE"] = taxCode;
    map["location"] = location;
    map["rec_amount"] = rec_amount;
    map["rec_curr"] = rec_curr;
    map["descript"] = descript;
    map["gst_no"] = gstNo;
    map["region"] = region;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["column_id"] = key;
    map["from_date1"] = fromDate;
    map["to_date1"] = toDate;
    map["country"] = country;
    map["state"] = state;
    map["city"] = city;
    map["exp_type"] = expenseType;
    map["TAX_CODE"] = taxCode;
    map["location"] = location;
    map["rec_amount"] = rec_amount;
    map["rec_curr"] = rec_curr;
    map["descript"] = descript;
    map["gst_no"] = gstNo;
    map["region"] = region;
    return map;
  }

  Map<String, dynamic> toJson() {
    final map = new Map<String, dynamic>();
    map["column_id"] = key;
    map["from_date1"] = fromDate;
    map["to_date1"] = toDate;
    map["country"] = country;
    map["state"] = state;
    map["city"] = city;
    map["exp_type"] = expenseType;
    map["TAX_CODE"] = taxCode;
    map["location"] = location;
    map["rec_amount"] = rec_amount;
    map["rec_curr"] = rec_curr;
    map["descript"] = descript;
    map["gst_no"] = gstNo;
    map["region"] = region;
    return map;
  }

  @override
  String toString() {
    return '{key: $key, fromDate: $fromDate, toDate: $toDate, country: $country, state: $state, city: $city, expenseType: $expenseType, taxCode: $taxCode, location: $location, rec_amount: $rec_amount, rec_curr: $rec_curr, descript: $descript, gstNo: $gstNo, region: $region}';
  }
}
