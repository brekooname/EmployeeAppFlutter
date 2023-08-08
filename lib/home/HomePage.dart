// ignore_for_file: library_prefixes

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shakti_employee_app/DailyReport/dailyReport.dart';
import 'package:shakti_employee_app/gatepass/gatepassApproved.dart';
import 'package:shakti_employee_app/gatepass/gatepassRequest.dart';
import 'package:shakti_employee_app/gatepass/model/PendingGatePassResponse.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/home/model/personalindoresponse.dart';
import 'package:shakti_employee_app/leave/LeaveRequest.dart';
import 'package:shakti_employee_app/officialDuty/officalRequest.dart';
import 'package:shakti_employee_app/officialDuty/officialApprove.dart';
import 'package:shakti_employee_app/task/taskApprove.dart';
import 'package:shakti_employee_app/task/taskRequest.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webReport/webreport.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../leave/LeaveApprove.dart';
import '../theme/string.dart';
import 'navigation_drawer_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String packageName = "null";
  String version = "null";
  String? nameValue = "null";
  bool isLoading = false;

  List<Leavebalance> leaveBalanceList = [];
  List<Activeemployee> activeEmployeeList = [];
  List<Attendanceemp> attendenceList = [];
  List<Leaveemp> leaveEmpList = [];
  List<Odemp> odEmpList = [];
  List<PendingTask> pendingTaskList = [];
  List<Pendingleave> pendingLeaveList = [];
  List<Pendingod> pendindOdList = [];
  List<Emp> personalInfo = [];
  List<Datum> gatePassList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleLocationPermission();
    downloadingData();
    getNameValue();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: appName,
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,

              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  detailWidget("Leave"),
                  const SizedBox(
                    height: 10,
                  ),
                  detailWidget("Official Duty"),
                  const SizedBox(
                    height: 10,
                  ),
                  detailWidget("Gate Pass"),
                  const SizedBox(
                    height: 10,
                  ),
                  detailWidget("Task"),
                  const SizedBox(
                    height: 10,
                  ),
                  localConvenience(),
                  const SizedBox(
                    height: 10,
                  ),
                  dailyAndWebReport("Daily Report", "assets/svg/approved.svg"),
                  const SizedBox(
                    height: 10,
                  ),
                  dailyAndWebReport("Web Report", "assets/svg/report.svg"),
                ],
              ),
            ),
          ),
          Center(
            child: isLoading == true
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : const SizedBox(),
          ),
        ],
      ),
      drawer: Drawer(
          backgroundColor: AppColor.whiteColor,
          child: NavigationDrawerWidget(
            name: nameValue!,
            attendenceList: attendenceList,
            leaveEmpList: leaveEmpList,
            odEmpList: odEmpList,
            personalInfo: personalInfo,
          )),
    );
  }

  detailWidget(String title) {
    return  SizedBox(
          height: MediaQuery.of(context).size.height/4,
          child: Card(
            color: AppColor.whiteColor,
            elevation: 10,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: AppColor.greyBorder,
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            ),
            child:Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/13,
                  color: AppColor.themeColor,
                     alignment: Alignment.center,
                     child: robotoTextWidget(textval: title,
                         colorval: Colors.white, sizeval: 12, fontWeight: FontWeight.w600),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      imageTextWidget("assets/svg/request.svg", "Request"),
                      dividerWidget(),
                      imageTextWidget("assets/svg/request.svg", "Request")
                    ],
                  ),
                )
              ],
            ),

        ));
  }

  localConvenience() {
    return  SizedBox(
        height: MediaQuery.of(context).size.height/4,
        child: Card(
          color: AppColor.whiteColor,
          elevation: 10,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.greyBorder,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
          child:Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/13,
                color: AppColor.themeColor,
                alignment: Alignment.center,
                child: robotoTextWidget(textval: 'Local Convenience',
                    colorval: Colors.white, sizeval: 12, fontWeight: FontWeight.w600),
              ),
              Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    imageTextWidget("assets/svg/start.svg", "Start"),
                    dividerWidget(),
                    imageTextWidget("assets/svg/end.svg", "End"),
                    dividerWidget(),
                    imageTextWidget("assets/svg/offline.svg", "Offline"),
                  ],
                ),
              )
            ],
          ),

        ));
  }

  dividerWidget(){
    return   Container(width: 1,
      height: MediaQuery.of(context).size.height/8,
      color: AppColor.grey,);
  }

  void RequestMethod(String title) {
    if (title == "Leave") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => LeaveRequestScreen(
                    LeaveBalanceList: leaveBalanceList,
                    activeEmpList: activeEmployeeList,
                  )),
          (route) => true);
    }

    if (title == "OfficialDuty") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => OfficialRequest(
                    activeemployeeList: activeEmployeeList,
                  )),
          (route) => true);
    }

    if (title == "Gatepass") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => GatepassRequestScreen(
                    activeemployeeList: activeEmployeeList,
                  )),
          (route) => true);
    }

    if (title == "Task") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => TaskRequestScreen(
                    activeemployeeList: activeEmployeeList,
                  )),
          (route) => true);
    }
  }

  void ApprovedMethod(String title) {
    if (title == "Leave") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => LeaveApproved(
                    pendingLeaveList: pendingLeaveList,
                  )),
          (route) => true);
    }

    if (title == "OfficialDuty") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  OfficialApproved(pendindOdList: pendindOdList)),
          (route) => true);
    }

    if (title == "Gatepass") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  GatePassApproved(gatePassList: gatePassList)),
          (route) => true);
    }

    if (title == "Task") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => TaskApproved(
                    pendingTaskList: pendingTaskList,
                    activeemployeeList: activeEmployeeList,
                  )),
          (route) => true);
    }
  }

  dailyAndWebReport(String title, String svg) {
    return  SizedBox(
        height: MediaQuery.of(context).size.height/4,
        child: Card(
          color: AppColor.whiteColor,
          elevation: 10,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.greyBorder,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
          child:Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/13,
                color: AppColor.themeColor,
                alignment: Alignment.center,
                child: robotoTextWidget(textval: title,
                    colorval: Colors.white, sizeval: 12, fontWeight: FontWeight.w600),
              ),
              Container(
                child: imageTextWidget(svg, title),
              )
            ],
          ),

        ));
  }

  Future<void> getNameValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameValue = preferences.getString(name);
    });
  }

  buildLocationDialog() {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: SizedBox(
              width: double.maxFinite,
              child: Container(),
            ),
          );
        });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> downloadingData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonData = null;
    var jsonData1 = null;

    dynamic response = await HTTP.get(SyncAndroidToSapAPI(
        sharedPreferences.getString(sapCodetxt).toString()));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      SyncAndroidToSapResponse androidToSapResponse =
          SyncAndroidToSapResponse.fromJson(jsonData);

      setState(() {
        leaveBalanceList = androidToSapResponse.leavebalance;

        leaveBalanceList
            .add(Leavebalance(leaveType: 'WITHOUT PAY-999.0', leaveBal: 999.0));

        activeEmployeeList = androidToSapResponse.activeemployee;

        attendenceList = androidToSapResponse.attendanceemp;

        odEmpList = androidToSapResponse.odemp;

        leaveEmpList = androidToSapResponse.leaveemp;

        pendingTaskList = androidToSapResponse.pendingtask;

        pendingLeaveList = androidToSapResponse.pendingleave;

        pendindOdList = androidToSapResponse.pendingod;
      });
    }

    dynamic response1 = await HTTP.get(
        personalInfoAPI(sharedPreferences.getString(sapCodetxt).toString()));
    if (response1 != null && response1.statusCode == 200) {
      jsonData1 = convert.jsonDecode(response1.body);
      PersonalInfoResponse _personalInfo =
          PersonalInfoResponse.fromJson(jsonData1);

      setState(() {
        isLoading = false;
        personalInfo = _personalInfo.emp;
      });
    }

    dynamic response2 = await HTTP.get(
        pendingGatePass(sharedPreferences.getString(sapCodetxt).toString()));
    if (response2 != null && response2.statusCode == 200) {
      jsonData1 = convert.jsonDecode(response2.body);
      PendingGatePassResponse pendingGatePassResponse =
          PendingGatePassResponse.fromJson(jsonData1);

      gatePassList = pendingGatePassResponse.data;
      setState(() {
        isLoading = false;
      });
    }
  }

  void screenNavigation(String title) {
    if (title == "Web Report") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WebScreen()),
          (route) => true);
    }

    if (title == "Daily Report") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DailyReport()),
          (route) => true);
    }
  }

  imageTextWidget(String svg, String msg) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: SvgPicture.asset(
              svg,
              width: 50,
              height: 50,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        robotoTextWidget(
            textval: msg,
            colorval: AppColor.themeColor,
            sizeval: 12,
            fontWeight: FontWeight.w600)
      ],
    );
  }
}
