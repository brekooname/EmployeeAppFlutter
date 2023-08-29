// To parse this JSON data, do
//
//     final vendorGatePassModel = vendorGatePassModelFromJson(jsonString);

import 'dart:convert';

VendorGatePassModel vendorGatePassModelFromJson(String str) => VendorGatePassModel.fromJson(json.decode(str));

String vendorGatePassModelToJson(VendorGatePassModel data) => json.encode(data.toJson());

class VendorGatePassModel {
  String status;
  String message;
  List<Response> response;

  VendorGatePassModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory VendorGatePassModel.fromJson(Map<String, dynamic> json) => VendorGatePassModel(
    status: json["status"],
    message: json["message"],
    response: json["response"] != null? List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String mandt;
  String docno;
  String bukrs;
  String vstpye;
  String passDate;
  String passTime;
  String leaveDate;
  String leaveTime;
  String nameVisitor;
  String telNumber;
  String company;
  String address;
  String city;
  String purpose;
  String purposeList;
  String contactPerson;
  String vehicleNo;
  String vendTyp;
  String lifnr;
  String land1;
  String name1;
  String ort01;
  String ort02;
  String regio;
  String stras;
  String telf2;
  String matkl;
  String matWithVis;
  String licenseNo;
  String pollutnCert;
  String threeTrilas;
  String fitnsCert;
  String permitExpiry;
  String vacOcc;
  String vacOccOut;
  String canteenCardNo;
  String pernr;
  String vehicleType;
  String busDriverName;
  String busHelperName;
  String busDriverId;
  String busHelperId;
  String noOfPassenger;
  String shift;
  String prevDayInd;
  String locationFrm;
  String locationTo;
  String km;
  String pernr1;
  String pernr2;
  String pernr3;
  String pernr4;
  String pernr5;
  String pernr6;
  String pernr7;
  String abkrs;
  String entryBy;
  String outRemark;
  String placeToVisit;
  String werks;


  Response({
    required this.mandt,
    required this.docno,
    required this.bukrs,
    required this.vstpye,
    required this.passDate,
    required this.passTime,
    required this.leaveDate,
    required this.leaveTime,
    required this.nameVisitor,
    required this.telNumber,
    required this.company,
    required this.address,
    required this.city,
    required this.purpose,
    required this.purposeList,
    required this.contactPerson,
    required this.vehicleNo,
    required this.vendTyp,
    required this.lifnr,
    required this.land1,
    required this.name1,
    required this.ort01,
    required this.ort02,
    required this.regio,
    required this.stras,
    required this.telf2,
    required this.matkl,
    required this.matWithVis,
    required this.licenseNo,
    required this.pollutnCert,
    required this.threeTrilas,
    required this.fitnsCert,
    required this.permitExpiry,
    required this.vacOcc,
    required this.vacOccOut,
    required this.canteenCardNo,
    required this.pernr,
    required this.vehicleType,
    required this.busDriverName,
    required this.busHelperName,
    required this.busDriverId,
    required this.busHelperId,
    required this.noOfPassenger,
    required this.shift,
    required this.prevDayInd,
    required this.locationFrm,
    required this.locationTo,
    required this.km,
    required this.pernr1,
    required this.pernr2,
    required this.pernr3,
    required this.pernr4,
    required this.pernr5,
    required this.pernr6,
    required this.pernr7,
    required this.abkrs,
    required this.entryBy,
    required this.outRemark,
    required this.placeToVisit,
    required this.werks,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    mandt: json["mandt"],
    docno: json["docno"],
    bukrs: json["bukrs"],
    vstpye: json["vstpye"],
    passDate: json["pass_date"],
    passTime: json["pass_time"],
    leaveDate: json["leave_date"],
    leaveTime: json["leave_time"],
    nameVisitor: json["name_visitor"],
    telNumber: json["tel_number"],
    company: json["company"],
    address: json["address"],
    city: json["city"],
    purpose: json["purpose"],
    purposeList: json["purpose_list"],
    contactPerson: json["contact_person"],
    vehicleNo: json["vehicle_no"],
    vendTyp: json["vend_typ"],
    lifnr: json["lifnr"],
    land1: json["land1"],
    name1: json["name1"],
    ort01: json["ort01"],
    ort02: json["ort02"],
    regio: json["regio"],
    stras: json["stras"],
    telf2: json["telf2"],
    matkl: json["matkl"],
    matWithVis: json["mat_with_vis"],
    licenseNo: json["license_no"],
    pollutnCert: json["pollutn_cert"],
    threeTrilas: json["three_trilas"],
    fitnsCert: json["fitns_cert"],
    permitExpiry: json["permit_expiry"],
    vacOcc: json["vac_occ"],
    vacOccOut: json["vac_occ_out"],
    canteenCardNo: json["canteen_card_no"],
    pernr: json["pernr"],
    vehicleType: json["vehicle_type"],
    busDriverName: json["bus_driver_name"],
    busHelperName: json["bus_helper_name"],
    busDriverId: json["bus_driver_id"],
    busHelperId: json["bus_helper_id"],
    noOfPassenger: json["no_of_passenger"],
    shift: json["shift"],
    prevDayInd: json["prev_day_ind"],
    locationFrm: json["location_frm"],
    locationTo: json["location_to"],
    km: json["km"],
    pernr1: json["pernr1"],
    pernr2: json["pernr2"],
    pernr3: json["pernr3"],
    pernr4: json["pernr4"],
    pernr5: json["pernr5"],
    pernr6: json["pernr6"],
    pernr7: json["pernr7"],
    abkrs: json["abkrs"],
    entryBy: json["entry_by"],
    outRemark: json["out_remark"],
    placeToVisit: json["place_to_visit"],
    werks: json["werks"],
  );

  Map<String, dynamic> toJson() => {
    "mandt": mandt,
    "docno": docno,
    "bukrs": bukrs,
    "vstpye": vstpye,
    "pass_date": passDate,
    "pass_time": passTime,
    "leave_date": leaveDate,
    "leave_time": leaveTime,
    "name_visitor": nameVisitor,
    "tel_number": telNumber,
    "company": company,
    "address": address,
    "city": city,
    "purpose": purpose,
    "purpose_list": purposeList,
    "contact_person": contactPerson,
    "vehicle_no": vehicleNo,
    "vend_typ": vendTyp,
    "lifnr": lifnr,
    "land1": land1,
    "name1": name1,
    "ort01": ort01,
    "ort02": ort02,
    "regio": regio,
    "stras": stras,
    "telf2": telf2,
    "matkl": matkl,
    "mat_with_vis": matWithVis,
    "license_no": licenseNo,
    "pollutn_cert": pollutnCert,
    "three_trilas": threeTrilas,
    "fitns_cert": fitnsCert,
    "permit_expiry": permitExpiry,
    "vac_occ": vacOcc,
    "vac_occ_out": vacOccOut,
    "canteen_card_no": canteenCardNo,
    "pernr": pernr,
    "vehicle_type": vehicleType,
    "bus_driver_name": busDriverName,
    "bus_helper_name": busHelperName,
    "bus_driver_id": busDriverId,
    "bus_helper_id": busHelperId,
    "no_of_passenger": noOfPassenger,
    "shift": shift,
    "prev_day_ind": prevDayInd,
    "location_frm": locationFrm,
    "location_to": locationTo,
    "km": km,
    "pernr1": pernr1,
    "pernr2": pernr2,
    "pernr3": pernr3,
    "pernr4": pernr4,
    "pernr5": pernr5,
    "pernr6": pernr6,
    "pernr7": pernr7,
    "abkrs": abkrs,
    "entry_by": entryBy,
    "out_remark": outRemark,
    "place_to_visit": placeToVisit,
    "werks": werks,
  };

  @override
  String toString() {
    return 'Response{mandt: $mandt, docno: $docno, bukrs: $bukrs, vstpye: $vstpye, passDate: $passDate, passTime: $passTime, leaveDate: $leaveDate, leaveTime: $leaveTime, nameVisitor: $nameVisitor, telNumber: $telNumber, company: $company, address: $address, city: $city, purpose: $purpose, purposeList: $purposeList, contactPerson: $contactPerson, vehicleNo: $vehicleNo, vendTyp: $vendTyp, lifnr: $lifnr, land1: $land1, name1: $name1, ort01: $ort01, ort02: $ort02, regio: $regio, stras: $stras, telf2: $telf2, matkl: $matkl, matWithVis: $matWithVis, licenseNo: $licenseNo, pollutnCert: $pollutnCert, threeTrilas: $threeTrilas, fitnsCert: $fitnsCert, permitExpiry: $permitExpiry, vacOcc: $vacOcc, vacOccOut: $vacOccOut, canteenCardNo: $canteenCardNo, pernr: $pernr, vehicleType: $vehicleType, busDriverName: $busDriverName, busHelperName: $busHelperName, busDriverId: $busDriverId, busHelperId: $busHelperId, noOfPassenger: $noOfPassenger, shift: $shift, prevDayInd: $prevDayInd, locationFrm: $locationFrm, locationTo: $locationTo, km: $km, pernr1: $pernr1, pernr2: $pernr2, pernr3: $pernr3, pernr4: $pernr4, pernr5: $pernr5, pernr6: $pernr6, pernr7: $pernr7, abkrs: $abkrs, entryBy: $entryBy, outRemark: $outRemark, placeToVisit: $placeToVisit, werks: $werks}';
  }
}
