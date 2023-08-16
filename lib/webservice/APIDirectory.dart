import 'package:flutter/material.dart';

import 'constant.dart';

const productionUrl = 'https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/zhr_emp_app_1/';
const googleDistanceMatrixAPI = 'https://maps.googleapis.com/maps/api/distancematrix/';

userLogin(String sapCode, String password ) {
  return Uri.parse('${productionUrl}login.htm?pernr=${sapCode}&pass=${password}');
}

forgotpasword(String sapCode ,String moile, String DOB){
  return Uri.parse('${productionUrl}forgot_password.htm?pernr=${sapCode}&mobno=${moile}&dob=${DOB}');
}

sendOTPAPI(String mobile, int otp){
  return Uri.parse('http://control.yourbulksms.com/api/sendhttp.php?authkey=393770756d707334373701&mobiles=${mobile}&message=Please%20Enter%20Following%20OTP%20To%20Reset%20Your%20Password%20${otp}%20SHAKTI%20GROUP&sender=SHAKTl&route=2&unicode=0&country=91&DLT_TE_ID=1707161726018508169');
}

SyncAndroidToSapAPI(String pernr){
  return Uri.parse('${productionUrl}sync_android_to_sap.htm?pernr=${pernr}');
}
getDistanceAPI(String origin,String destination){
  return Uri.parse('${googleDistanceMatrixAPI}json?origins=$origin&destinations=$destination&key=$googleApiKey');
}
//https://maps.googleapis.com/maps/api/distancematrix/json?destinations=40.659569,-73.933783
// &origins=40.6655101,-73.89188969999998&key=AIzaSyAohhwZ11LRwoxsS8lJ0VHGkA4L-cwjWmw
createLeaveAPI(String sapCode, String leavetype, String leaveDuration, String from, String To, String reason, String pInC1,String pInC2,String pInC3,String pInC4){
  return Uri.parse('${productionUrl}leave_create.htm?app_pernr=${sapCode}&app_leave_type=${leavetype}&app_leave_duration=${leaveDuration}&app_leave_from=${from}&app_leave_to=${To}&app_leave_reason=${reason}&app_per_chrg1=${pInC1}&app_per_chrg2=${pInC2}&app_per_chrg3=${pInC3}&app_per_chrg4=${pInC4}');
}

createTaskAPI(String value){
  return Uri.parse('${productionUrl}sync_offline_data.htm?TASK_CREATED=${value}');
}

createODAPI(String app_pernr, String atnds_status, String app_od_from, String app_od_to , String app_od_visitplace, String app_od_workplace, String st_od_purpose1, String st_od_purpose2, String st_od_purpose3, String st_od_remark , String st_od_charge){
  return Uri.parse('${productionUrl}od_create.htm?app_pernr=${app_pernr}&atnds_status=${atnds_status}&app_od_from=${app_od_from}&app_od_to=${app_od_to}&app_od_visitplace=${app_od_visitplace}&app_od_workplace=${app_od_workplace}&app_od_purpose1=${st_od_purpose1}&app_od_purpose2=${st_od_purpose2}&app_od_purpose3=${st_od_purpose3}&app_od_remark=${st_od_remark}&app_od_charge=${st_od_charge}');
}

approveODAPI(String drno, String sapcode, String pass){
  return Uri.parse('${productionUrl}od_approve.htm?od_no=${drno}&approver=${sapcode}&password=${pass}');
}

rejectODAPI(String drno, String sapcode, String pass){
  return Uri.parse('${productionUrl}od_reject_form.htm?od_no=${drno}&approver=${sapcode}&password=${pass}');
}

personalInfoAPI(String sapCode){
  return Uri.parse('${productionUrl}employee_info.htm?pernr=${sapCode}');
}

completeTaskAPI(String value){
  return Uri.parse('${productionUrl}sync_offline_data.htm?TASK_COMPLETED=${value}');
}

createGatePassAPI(String sapCode, String fromDate, String fromTime, String type ,String gptype, String comebackDate, String comebackTime, String vplace , String purpose, String charge){
  return Uri.parse('${productionUrl}gp_create.htm?app_pernr=${sapCode}&gp_date=${fromDate}&gp_time=${fromTime}&req_type=${type}&gp_type=${gptype}&gp_exp_date=${comebackDate}&gp_exp_time=${comebackTime}&gp_vp=${vplace}&gp_purpose=${purpose}&gp_charge=${charge}');
}

approveLeaveAPI(int drno, String sapcode, String pass){
  return Uri.parse('${productionUrl}leave_approve.htm?leave_no=${drno}&approver=${sapcode}&password=${pass}');
}

pendingGatePass(String sapCode){
  return Uri.parse('${productionUrl}gatepass_approval_pending.htm?app_pernr=${sapCode}');
}

approveGatePassAPI(int prner,int drno,  String sapcode,  String status){
  return Uri.parse('${productionUrl}gatepass_approva_rejectl.htm?pernr=${prner}&gp_no=${drno}&app_pernr=${sapcode}&status=${status}');
}

rejectLeaveAPI(int drno, String sapcode, String pass){
  return Uri.parse('${productionUrl}leave_reject.htm?leave_no=${drno}&approver=${sapcode}&password=${pass}');
}

vendorNameAPI(String value){
  return Uri.parse('${productionUrl}vendor_details_all.htm?name=${value}');
}

syncLocalConveyanceAPI(String value){
  return Uri.parse('${productionUrl}start_end_location.htm?travel_distance=${value}');
}

vendorOpenGatepass(String sapCode){
  return Uri.parse('${productionUrl}vendor_open_gatepass.htm?pernr=${sapCode}');
}

DailyReportAPI(String value){
  return Uri.parse('${productionUrl}mom_daily_reportinf.htm?final=${value}');
}
