import 'package:flutter/material.dart';
import 'package:shakti_employee_app/theme/string.dart';

import 'constant.dart';

const productionUrl = 'https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/zhr_emp_app_1/';
const googleDistanceMatrixAPI = 'https://maps.googleapis.com/maps/api/directions/';
const dashboardAppUrl ='https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/zshakti_dash/';

userLogin(String sapCode, String password, String api_version,  String api, String app_version, String imei , String os, String fcm_token,String loginUserType) {
  return Uri.parse('${productionUrl}login.htm?pernr=${sapCode}&pass=${password}&api_version=${api_version}&api=${api}&app_version=${app_version}&imei=${imei}&os=${os}&fcm_token=${fcm_token}&islogin=${loginUserType}');
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

getDistanceAPI(String origin,String destination,String waypoints){
  return Uri.parse('${googleDistanceMatrixAPI}json?origin=$origin&destination=$destination&waypoints=$waypoints&key=$googleApiKey');
}

createLeaveAPI(String sapCode, String leavetype, String leaveDuration, String fromDate, String toDate,
    String fromTime, String toTime, String reason, String pInC1,String pInC2,String pInC3,String pInC4){
  return Uri.parse('${productionUrl}leave_create.htm?app_pernr=${sapCode}&app_leave_type=${leavetype}'
      '&app_leave_duration=${leaveDuration}&app_leave_from=${fromDate}&app_leave_to=${toDate}&tim_fr=${fromTime}&tim_to=${toTime}&app_leave_reason=${reason}'
      '&app_per_chrg1=${pInC1}&app_per_chrg2=${pInC2}&app_per_chrg3=${pInC3}&app_per_chrg4=${pInC4}');
}

createTaskAPI(String value){
  return Uri.parse('${productionUrl}sync_offline_data.htm?TASK_CREATED=${value}');
}

createODAPI(String app_pernr, String atnds_status, String app_od_from, String app_od_to , String app_od_visitplace, String app_od_workplace, String st_od_purpose1, String st_od_purpose2, String st_od_purpose3, String st_od_remark , String st_od_charge, String fromTime){
  return Uri.parse('${productionUrl}od_create.htm?app_pernr=${app_pernr}&atnds_status=${atnds_status}'
      '&app_od_from=${app_od_from}&app_od_to=${app_od_to}&app_od_visitplace=${app_od_visitplace}'
      '&app_od_workplace=${app_od_workplace}&app_od_purpose1=${st_od_purpose1}&app_od_purpose2=${st_od_purpose2}'
      '&app_od_purpose3=${st_od_purpose3}&app_od_remark=${st_od_remark}&app_od_charge=${st_od_charge}&Frm_tim=${fromTime}');
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

approveGatePassAPI(String prner,String drno,  String sapcode,  String status){
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
  return Uri.parse('${productionUrl}vendor_open_gatepass.htm?pernr=$sapCode');
}

DailyReportAPI(String value){
  return Uri.parse('${productionUrl}mom_daily_reportinf.htm?final=${value}');
}

getDepartment() {
  return Uri.parse('${dashboardAppUrl}dept_api.htm');
}
getTotalTaskCountList(String DeptCode, String empCode, String fromDate, String toDate) {
  return Uri.parse(
      '${dashboardAppUrl}task_api.htm?depart=$DeptCode&emp=$empCode&date1=$fromDate&date2=$toDate');
}

getTaskList(String subDeptCode, String empCode, String fromDate, String toDate, String type) {
  return Uri.parse('${dashboardAppUrl}task_list.htm?depart=$subDeptCode&emp=$empCode&date1=$fromDate&date2=$toDate&type=$type');
}

getCountryListAPI(){
  return Uri.parse('${productionUrl}country.htm');
}

getStateListAPI(String county){
  return Uri.parse('${productionUrl}state.htm?land1=${county}');
}

getCityListAPI(String county, String state){
  return Uri.parse('${productionUrl}dictrict1.htm?land1=${county}&regio=${state}');
}

getRegionListAPI(String county, String state, String city){
  return Uri.parse('${productionUrl}city_list_grade_api.htm?land1=${county}&regio=${state}&district=${city}');
}

getTravelRequestAPI(String value){
  return Uri.parse('${productionUrl}savetraveldata.htm?final=${value}');
}

getTravelRequestAPIList(String sapCode){
  return Uri.parse('${productionUrl}travel_approval_list.htm?pernr=${sapCode}');
}

sendTravelRequestStatus (String docNo, String hodPernr, String perner ,String Status){
  return Uri.parse('${productionUrl}save_approve_reject.htm?hod_pernr=${hodPernr}&pernr=${perner}&status=${Status}&docno=${docNo}');
}

getTravelListResponseAPI(String sapCode , String fromDate, String toDate){
  return Uri.parse('${productionUrl}report_travel.htm?from=${fromDate}&to=${toDate}&pernr=${sapCode}');
}

getTravelDropDown(){
  return Uri.parse('${productionUrl}ldrop_list_api.htm');
}

createAttendenceCorrectionAPI(String sapCode , String fromDate, String spinnerType,String remark){
  return Uri.parse('${productionUrl}attendance_correction.htm?date=${fromDate}&perno=${sapCode}&status=${spinnerType}&remark=${remark}');
}

sendTravelExpense(String date1 ,String date2 ,String country ,String location, String cost_center,String perno,String trip_details){
  return Uri.parse('${productionUrl}travel_expense_entry.htm?date1=${date1}&date2=${date2}&country=${country}&location=${location}&cost_center=${cost_center}&perno=${perno}&trip_details=${trip_details}');
}
getCOffDateListApi(String sapCode){
  return Uri.parse('${productionUrl}zattendanc_c_off.htm?sap_code=${sapCode}');
}
cOffReqApi(String value){
  return Uri.parse('${productionUrl}c_off_save.htm?post=${value}');
}
cOffReqListApi(String sapCode){
  return Uri.parse('${productionUrl}coff_approval_pending.htm?app_pernr=${sapCode}');
}

cOffAppRejApi(String value){
  return Uri.parse('${productionUrl}coff_hod_app_reject.htm?app=$value');
}

getShiftTypeList( ){
  return Uri.parse('${productionUrl}shift_data.htm');
}

sendShiftData(String value) {
  return Uri.parse('${productionUrl}shift_correct.htm?post=$value');
}

pendingShiftData(String sapCode){
  return Uri.parse('${productionUrl}shift_approval.htm?app_pernr=${sapCode}');
}

shiftApproveAPI(String value){
 return Uri.parse('${productionUrl}shift_hod_app_rej.htm?app=${value}');
}