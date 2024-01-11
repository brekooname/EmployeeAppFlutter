

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
  String amount;
  String currency;
  String description;
  String gstNo;

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
    required this.amount,
    required this.currency,
    required this.description,
    required this.gstNo,
  });

  factory TravelExpenseModel.fromMap(Map<String, dynamic> json) => TravelExpenseModel(
    key: json["column_id"]?? "",
    fromDate: json["from_date"]?? "",
    toDate: json["to_date"]?? "",
    country: json["country"]?? "",
    state: json["state"]?? "",
    city: json["city"]?? "",
    expenseType: json["expense_type"]?? "",
    taxCode: json["tax_code"]?? "",
    location: json["location"]?? "",
    amount: json["amount"]?? "",
    currency: json["currency"]?? "",
    description: json["description"]?? "",
    gstNo: json["gst_no"]?? "",
  );



  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["from_date"] = fromDate;
    map["to_date"] = toDate;
    map["country"] = country;
    map["state"] = state;
    map["city"] = city;
    map["expense_type"] = expenseType;
    map["tax_code"] = taxCode;
    map["location"] = location;
    map["amount"] = amount;
    map["currency"] = currency;
    map["description"] = description;
    map["gst_no"] = gstNo;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["column_id"] = key;
    map["from_date"] = fromDate;
    map["to_date"] = toDate;
    map["country"] = country;
    map["state"] = state;
    map["city"] = city;
    map["expense_type"] = expenseType;
    map["tax_code"] = taxCode;
    map["location"] = location;
    map["amount"] = amount;
    map["currency"] = currency;
    map["description"] = description;
    map["gst_no"] = gstNo;
    return map;
  }

  @override
  String toString() {
    return 'TravelExpenseModel{key: $key, fromDate: $fromDate, toDate: $toDate, country: $country, state: $state, city: $city, expenseType: $expenseType, taxCode: $taxCode, location: $location, amount: $amount, currency: $currency, description: $description, gstNo: $gstNo}';
  }
}
