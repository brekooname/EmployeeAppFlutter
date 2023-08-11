// ignore_for_file: library_prefixes

import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shakti_employee_app/DailyReport/dailyReport.dart';
import 'package:shakti_employee_app/Util/utility.dart';
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
import '../webservice/constant.dart';
import 'navigation_drawer_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key,required this.journeyStart}) : super(key: key);

  String journeyStart;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  LatLng? latlong = null;
  String packageName = "",
      version = "",
      nameValue = "",
      formattedDate = "",
      Address = "",placeName = "",isoId="",journeyStart = "";
  bool isLoading = false;
  late SharedPreferences sharedPreferences;
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
  SyncAndroidToSapResponse? syncAndroidToSapResponse;
  PersonalInfoResponse? personInfo;
  PendingGatePassResponse? gatePassResponse;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    journeyStart = widget.journeyStart;
    _handleLocationPermission();
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
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) =>
            [
              // PopupMenuItem 1
              const PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.download_for_offline,
                      color: AppColor.themeColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    robotoTextWidget(
                        textval: 'Downloading Data',
                        colorval: AppColor.themeColor,
                        sizeval: 16,
                        fontWeight: FontWeight.w600)
                  ],
                ),
              ),
            ],

            color: Colors.white,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                downloadingData();
                // if value 2 show dialog
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Column(
                children: [
                  detailWidget("Leave"),
                  detailWidget("Official Duty"),
                  detailWidget("Gate Pass"),
                  detailWidget("Task"),
                  localConvenience(),
                  dailyAndWebReport("Daily Report", "assets/svg/approved.svg"),
                  dailyAndWebReport("Web Report", "assets/svg/report.svg"),
                ],
              ),
            ),
          ),
          Center(
            child: isLoading == true
                ? const CircularProgressIndicator(
              color: Colors.indigo,
            )
                : const SizedBox(),
          ),
        ],
      ),
      drawer: Drawer(
          backgroundColor: AppColor.whiteColor,
          child: NavigationDrawerWidget(
            name: nameValue,
            attendenceList: attendenceList,
            leaveEmpList: leaveEmpList,
            odEmpList: odEmpList,
            personalInfo: personalInfo,
          )),
    );
  }

  detailWidget(String title) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
        color: AppColor.whiteColor,
        elevation: 10,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: AppColor.greyBorder,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 18,
              color: AppColor.themeColor,
              alignment: Alignment.center,
              child: robotoTextWidget(
                  textval: title,
                  colorval: Colors.white,
                  sizeval: 12,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageTextWidget("assets/svg/request.svg", "Request", title),
                  dividerWidget(),
                  imageTextWidget("assets/svg/approved.svg", "Approve", title)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  localConvenience() {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Card(
          color: AppColor.whiteColor,
          elevation: 5,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.greyBorder,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 18,
                color: AppColor.themeColor,
                alignment: Alignment.center,
                child: const robotoTextWidget(
                    textval: 'Local Convenience',
                    colorval: Colors.white,
                    sizeval: 12,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    localConvenceWidget("assets/svg/start.svg", start, ""),
                    dividerWidget(),
                    localConvenceWidget("assets/svg/end.svg", end, ""),
                    dividerWidget(),
                    imageTextWidget("assets/svg/offline.svg", Offline, ""),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  dividerWidget() {
    return Container(
      width: 1,
      margin: EdgeInsets.only(top: 15),
      height: MediaQuery
          .of(context)
          .size
          .height / 8,
      color: AppColor.grey,
    );
  }

  dailyAndWebReport(String title, String svg) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Card(
          color: AppColor.whiteColor,
          elevation: 10,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.greyBorder,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 18,
                color: AppColor.themeColor,
                alignment: Alignment.center,
                child: robotoTextWidget(
                    textval: title,
                    colorval: Colors.white,
                    sizeval: 12,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: imageTextWidget(svg, title, title),
              )
            ],
          ),
        ));
  }

  void requestMethod(String title) {
    switch (title) {
      case "Leave":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      LeaveRequestScreen(
                        LeaveBalanceList: leaveBalanceList,
                        activeEmpList: activeEmployeeList,
                      )),
                  (route) => true);
        }
        break;
      case "Official Duty":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      OfficialRequest(
                        activeemployeeList: activeEmployeeList,
                      )),
                  (route) => true);
        }
        break;
      case "Gate Pass":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      GatepassRequestScreen(
                        activeemployeeList: activeEmployeeList,
                      )),
                  (route) => true);
        }
        break;
      case "Task":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      TaskRequestScreen(
                        activeemployeeList: activeEmployeeList,
                      )),
                  (route) => true);
        }
        break;
    }
  }

  void approvedMethod(String title) {
    switch (title) {
      case "Leave":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      LeaveApproved(
                        pendingLeaveList: pendingLeaveList,
                      )),
                  (route) => true);
        }
        break;
      case "Official Duty":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      OfficialApproved(pendindOdList: pendindOdList)),
                  (route) => true);
        }
        break;
      case "Gate Pass":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      GatePassApproved(gatePassList: gatePassList)),
                  (route) => true);
        }
        break;
      case "Task":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      TaskApproved(
                        pendingTaskList: pendingTaskList,
                        activeemployeeList: activeEmployeeList,
                      )),
                  (route) => true);
        }
        break;
    }
  }

  Future<void> getNameValue() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nameValue = sharedPreferences.getString(name)!;
    });
    if (sharedPreferences.getString(currentDate) != null) {
      if (formattedDate !=
          sharedPreferences.getString(currentDate).toString()) {
        downloadingData();
      } else {
        getSPArrayList();
      }
    } else {
      downloadingData();
    }
  }

  void getSPArrayList() async {
    if (sharedPreferences.getString(syncSapResponse) != null &&
        sharedPreferences.getString(syncSapResponse).toString().isNotEmpty) {
      var jsonData =
          convert.jsonDecode(sharedPreferences.getString(syncSapResponse)!);
      syncAndroidToSapResponse = SyncAndroidToSapResponse.fromJson(jsonData);

      setListData();
    }

    if (sharedPreferences.getString(userInfo) != null &&
        sharedPreferences.getString(userInfo).toString().isNotEmpty) {
      var jsonData = convert.jsonDecode(sharedPreferences.getString(userInfo)!);
      personInfo = PersonalInfoResponse.fromJson(jsonData);
      setpersonData();
    }

    if (sharedPreferences.getString(gatePassDatail) != null &&
        sharedPreferences.getString(gatePassDatail).toString().isNotEmpty) {
      var jsonData =
          convert.jsonDecode(sharedPreferences.getString(gatePassDatail)!);
      gatePassResponse = PendingGatePassResponse.fromJson(jsonData);
      setgatePassData();
    }
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

    var jsonData = null;
    var jsonData1 = null;

    dynamic response = await HTTP.get(
        SyncAndroidToSapAPI(sharedPreferences.getString(userID) as String));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      SyncAndroidToSapResponse androidToSapResponse =
          SyncAndroidToSapResponse.fromJson(jsonData);
      setState(() {
        syncAndroidToSapResponse = androidToSapResponse;
        Utility()
            .setSharedPreference(syncSapResponse, response.body.toString());
        Utility().setSharedPreference(currentDate, formattedDate);
      });
      setListData();
    }

    dynamic response1 = await HTTP
        .get(personalInfoAPI(sharedPreferences.getString(userID).toString()));
    if (response1 != null && response1.statusCode == 200) {
      jsonData1 = convert.jsonDecode(response1.body);
      PersonalInfoResponse _personalInfo =
          PersonalInfoResponse.fromJson(jsonData1);
      if (_personalInfo.emp.isNotEmpty) {
        setState(() {
          personInfo = _personalInfo;
          isLoading = false;
          personalInfo = _personalInfo.emp;
          Utility().setSharedPreference(userInfo, response1.body.toString());
        });
        setpersonData();
      }
    }

    dynamic response2 = await HTTP
        .get(pendingGatePass(sharedPreferences.getString(userID).toString()));
    if (response2 != null && response2.statusCode == 200) {
      jsonData1 = convert.jsonDecode(response2.body);
      PendingGatePassResponse pendingGatePassResponse =
          PendingGatePassResponse.fromJson(jsonData1);
      if (pendingGatePassResponse.data.isNotEmpty) {
        setState(() {
          gatePassList = pendingGatePassResponse.data;
          gatePassResponse = pendingGatePassResponse;
          isLoading = false;
          Utility()
              .setSharedPreference(gatePassDatail, response2.body.toString());
        });
        setgatePassData();
      }
    }
  }

  imageTextWidget(String svg, String msg, String title) {
    return GestureDetector(
      onTap: () {
        switch (msg) {
          case "Request":
            {
              requestMethod(title);
            }
            break;
          case "Approve":
            {
              approvedMethod(title);
            }
            break;
          case "Offline":
            {}
            break;
          case "Daily Report":
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DailyReport()),
                      (route) => true);
            }
            break;
          case "Web Report":
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WebReport()),
                      (route) => true);
            }
            break;
        }
      },
      child: Column(
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
          const SizedBox(
            height: 4,
          ),
          robotoTextWidget(
              textval: msg,
              colorval: AppColor.themeColor,
              sizeval: 12,
              fontWeight: FontWeight.w600)
        ],
      ),
    );
  }

  void setListData() {
    if (syncAndroidToSapResponse != null) {
      setState(() {
        leaveBalanceList = syncAndroidToSapResponse!.leavebalance;
        leaveBalanceList
            .add(Leavebalance(leaveType: 'WITHOUT PAY-999.0', leaveBal: 999.0));
        activeEmployeeList = syncAndroidToSapResponse!.activeemployee;
        attendenceList = syncAndroidToSapResponse!.attendanceemp;
        odEmpList = syncAndroidToSapResponse!.odemp;
        leaveEmpList = syncAndroidToSapResponse!.leaveemp;
        pendingTaskList = syncAndroidToSapResponse!.pendingtask;
        pendingLeaveList = syncAndroidToSapResponse!.pendingleave;
        pendindOdList = syncAndroidToSapResponse!.pendingod;
      });
    }
  }

  void setpersonData() {
    if (personInfo != null && personInfo!.emp.isNotEmpty) {
      setState(() {
        personalInfo = personInfo!.emp;
      });
    }
  }

  void setgatePassData() {
    if (gatePassResponse != null && gatePassResponse!.data.isNotEmpty) {
      setState(() {
        gatePassList = gatePassResponse!.data;
      });
    }
  }
  Future getCurrentLocation() async {
    if (Platform.isAndroid) {
      var permission = Permission.locationWhenInUse.status;
      if (permission != PermissionStatus.granted) {
        final status = await Permission.location.request();
        if (status != PermissionStatus.granted) {
          Utility().showToast("You need location permission for use this App");
          return;
        }
      }
    }

    if (Platform.isIOS) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission != PermissionStatus.granted) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission != PermissionStatus.granted) getLocation();
        return;
      }
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if(mounted) {
      setState(() {
        latlong = LatLng(position.latitude, position.longitude);
        GetAddressFromLatLong(latlong!);
      });
    }
  }

  Future<void> GetAddressFromLatLong(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'en');
      Placemark place = placemarks[0];
      placeName = (place.subLocality != '')
          ? place.subLocality!
          : place.subAdministrativeArea!;
      isoId = place.isoCountryCode!;

      if(mounted) {
        setState(() {
          Address = '${place.street}, ${place.subLocality}, ${place.locality}';
          Address = Utility().formatAddress(Address);

        });
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => startJourneyPopup(context),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => startJourneyPopup(context),
      );
    }
  }

  startJourneyPopup(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: robotoTextWidget(
                    textval: appName,
                    colorval: AppColor.themeColor,
                    sizeval: 16,
                    fontWeight: FontWeight.bold),
              ),

              latLongWidget('Latitude:-  ${latlong!.latitude}',),
              latLongWidget('Longitude:-  ${latlong!.longitude}',),
              latLongWidget('Address:-$Address',),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: cancel,
                        colorval: AppColor.darkGrey,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                       setState(() {
                         journeyStart = True;
                         Utility().setSharedPreference(journeyStart, True);
                       });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: confirm,
                        colorval: AppColor.whiteColor,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ])));
  }

  latLongWidget(String title) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          robotoTextWidget(textval: title,
              colorval: Colors.black,
              sizeval: 12,
              fontWeight: FontWeight.normal),
          SizedBox(height: 5,),
          Divider(),
        ],
      ),
    );
  }

  localConvenceWidget(String svg, String msg, String title) {
    return GestureDetector(
      onTap: () {
        switch (msg) {
          case "Start":{
            if(journeyStart == False) {
              getCurrentLocation();
              setState(() {
                isLoading = true;
              });
            }
            }
            break;
          case "End":{
            if(journeyStart == True) {
              setState(() {
                journeyStart = False;
                Utility().setSharedPreference(journeyStart, False);
              });
            }
            }
            break;
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: loadSvg(msg,svg),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          robotoTextWidget(
              textval: msg,
              colorval: AppColor.themeColor,
              sizeval: 12,
              fontWeight: FontWeight.w600)
        ],
      ),
    );
  }

  loadSvg( String msg, String svg) {
    if(journeyStart == True && msg == start){
      return Opacity(
        opacity: 0.42,
        child: SvgPicture.asset(
          svg,
          width: 50,
          height: 50,
        ),
      );
    }

    if(journeyStart == False && msg == start){
      return  SvgPicture.asset(
          svg,
          width: 50,
          height: 50,
      );
    }

    if(journeyStart == True && msg==end){
      return  SvgPicture.asset(
          svg,
          width: 50,
          height: 50,
      );
    }

    if(journeyStart == False && msg == end){
      return Opacity(
        opacity: 0.42,
        child: SvgPicture.asset(
          svg,
          width: 50,
          height: 50,
        ),
      );
    }
  }

}
