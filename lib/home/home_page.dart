import 'dart:convert' as convert;

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/DailyReport/dailyReport.dart';
import 'package:shakti_employee_app/DailyReport/model/vendor_gate_pass_model.dart'
    as vendorGatePassPrefix;

import 'package:shakti_employee_app/TravelExpenses/travelexpenses.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/gatepass/gatepassApproved.dart';
import 'package:shakti_employee_app/gatepass/gatepassRequest.dart';
import 'package:shakti_employee_app/gatepass/model/PendingGatePassResponse.dart';
import 'package:shakti_employee_app/home/model/FirestoreDataModel.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/home/model/WayPointsModel.dart';
import 'package:shakti_employee_app/home/model/distance_calculate_model.dart'
    as distancePrefix;
import 'package:shakti_employee_app/home/model/personalindoresponse.dart';
import 'package:shakti_employee_app/leave/LeaveRequest.dart';
import 'package:shakti_employee_app/officialDuty/officalRequest.dart';
import 'package:shakti_employee_app/officialDuty/officialApprove.dart';
import 'package:shakti_employee_app/provider/BackgroundLocationService.dart';
import 'package:shakti_employee_app/provider/firestore_appupdate_notifier.dart';
import 'package:shakti_employee_app/task/taskApprove.dart';
import 'package:shakti_employee_app/task/taskRequest.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/travelrequest/model/travelrequestlist.dart'as TR;
import 'package:shakti_employee_app/travelrequest/travelApprove.dart';
import 'package:shakti_employee_app/travelrequest/travelrequest.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webReport/webreport.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../leave/LeaveApprove.dart';
import '../notificationService/local_notification_service.dart';
import '../theme/string.dart';
import '../uiwidget/appupdatewidget.dart';
import '../webservice/constant.dart';
import 'model/local_convence_model.dart';
import 'model/travelmodel.dart';
import 'navigation_drawer_widget.dart';
import 'offline_local_convenyance.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.journeyStart}) : super(key: key);

  String journeyStart;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? latlong;
  String packageName = "",
      version = "",
      nameValue = "",
      formattedDate = "",
      Address = "",
      placeName = "",
      isoId = "",
      journeyStart = "",
      allLatLng = "",
      UserID = "",
      appVersionCode = "";
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
  List<TR.Response> travelReqList = [];
  List<vendorGatePassPrefix.Response> vendorGatePassList = [];
  List<TravelModel> travelList = [];
  List<LocalConveyanceModel> localConveyanceList = [];
  List<WayPointsModel> wayPointList = [];
  SyncAndroidToSapResponse? syncAndroidToSapResponse;
  PersonalInfoResponse? personInfo;
  PendingGatePassResponse? gatePassResponse;
  vendorGatePassPrefix.VendorGatePassModel? vendorGatePassModel;
  TR.TravelRequestList? travelRequestList;
  TextEditingController travelModeController = TextEditingController();
  FirestoreDataModel? fireStoreDataModel;
  BackgroundLocationService? backgroundLocationService;

  var totalWayPoints ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    journeyStart = widget.journeyStart;

    _handleLocationPermission();
    getNameValue();
    receiveNotification();
  }


  void receiveNotification() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
      backgroundLocationService = Provider.of<BackgroundLocationService>(context,listen: true);

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
            itemBuilder: (context) => [
              // PopupMenuItem 1
                PopupMenuItem(
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
                        textval: downloadingDataTxt,
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
                Utility().checkInternetConnection().then((connectionResult) {
                  if (connectionResult) {
                   downloadingData();
                  } else {
                    Utility()
                        .showInSnackBar(value: checkInternetConnection, context: context);
                  }
                });
              }
            },
          ),
        ],
      ),
      body: Consumer<firestoreAppUpdateNofifier>(
          builder: (context, value, child) {
        if (value.fireStoreData != null && value.fireStoreData!.minEmployeeAppVersion !=
            value.appVersionCode) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => AppUpdateWidget(
                          appUrl:
                              value.fireStoreData!.employeeAppUrl.toString())),
                  (Route<dynamic> route) => false);

          });
        } else {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      detailWidget(leave),
                      detailWidget(officialDuty),
                      detailWidget(gatePasstxt),
                      detailWidget(task),
                      detailWidget(travel),
                      localConvenience(),
                      dailyAndWebReport(travelEx, "assets/svg/request.svg"),
                      dailyAndWebReport(dailyReport, "assets/svg/approved.svg"),
                      dailyAndWebReport(webReport, "assets/svg/report.svg"),
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
          );
        }
        return Container(
        );
      }),
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
      margin: const EdgeInsets.only(top: 5),
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
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 18,
                color: AppColor.themeColor,
                alignment: Alignment.center,
                child: robotoTextWidget(
                    textval: title,
                    colorval: Colors.white,
                    sizeval: 12,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageTextWidget("assets/svg/request.svg", request, title),
                    dividerWidget(),
                    imageTextWidget("assets/svg/approved.svg",
                        title == task ? close : approve, title)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  localConvenience() {
    return Container(
        margin: const EdgeInsets.only(top: 5),
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
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  color: AppColor.themeColor,
                  alignment: Alignment.center,
                  child: const robotoTextWidget(
                      textval: 'Local Convenience',
                      colorval: Colors.white,
                      sizeval: 12,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
          ),
        ));
  }

  dividerWidget() {
    return Container(
      width: 1,
      margin: const EdgeInsets.only(top: 15),
      height: MediaQuery.of(context).size.height / 8,
      color: AppColor.grey,
    );
  }

  dailyAndWebReport(String title, String svg) {
    return Container(
        margin: const EdgeInsets.only(top: 5),
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
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  color: AppColor.themeColor,
                  alignment: Alignment.center,
                  child: robotoTextWidget(
                      textval: title,
                      colorval: Colors.white,
                      sizeval: 12,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: imageTextWidget(svg, title, title),
                )
              ],
            ),
          ),
        ));
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
      Utility().showInSnackBar(
          value: 'Location services are disabled. Please enable the services',
          context: context);

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utility().showInSnackBar(
            value: 'Location permissions are denied', context: context);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Utility().showInSnackBar(
          value:
              'Location permissions are permanently denied, we cannot request permissions.',
          context: context);
      return false;
    }
    return true;
  }

  Future<void> getNameValue() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString(name)!=null && sharedPreferences.getString(name)!.isNotEmpty){
    setState(() {
      nameValue = sharedPreferences.getString(name)!;
      UserID = sharedPreferences.getString(userID)!;
    });
    }
   readNotifier();
    if (sharedPreferences.getString(currentDate) != null) {
      if (formattedDate !=
          sharedPreferences.getString(currentDate).toString()) {
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
            downloadingData();
          } else {
            Utility()
                .showInSnackBar(value: checkInternetConnection, context: context);
          }
        });
      } else {
        getSPArrayList();
      }
    } else {
      Utility().checkInternetConnection().then((connectionResult) {
        if (connectionResult) {
          downloadingData();
        } else {
          Utility()
              .showInSnackBar(value: checkInternetConnection, context: context);
        }
      });
    }
  }
  void readNotifier() {
    context.read<firestoreAppUpdateNofifier>().listenToLiveUpdateStream();
  }
  void getSPArrayList() async {
    if (sharedPreferences.getString(syncSapResponse) != null &&
        sharedPreferences.getString(syncSapResponse).toString().isNotEmpty) {
      var jsonData =
          convert.jsonDecode(sharedPreferences.getString(syncSapResponse)!);
      syncAndroidToSapResponse = SyncAndroidToSapResponse.fromJson(jsonData);

      setListData();
    }

    if (sharedPreferences.getString(userInfo) != null) {
      var jsonData = convert.jsonDecode(sharedPreferences.getString(userInfo)!);
      personInfo = PersonalInfoResponse.fromJson(jsonData);
      setpersonData();
    }

    if (sharedPreferences.getString(gatePassDatail) != null) {
      var jsonData =
          convert.jsonDecode(sharedPreferences.getString(gatePassDatail)!);
      gatePassResponse = PendingGatePassResponse.fromJson(jsonData);
      setgatePassData();
    }

    if (sharedPreferences.getString(travelRequest) != null) {
      var jsonData =
      convert.jsonDecode(sharedPreferences.getString(travelRequest)!);
      travelRequestList = TR.TravelRequestList.fromJson(jsonData);
      setTravelData();
    }

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(vendorGatePas) != null &&
        sharedPreferences.getString(vendorGatePas).toString().isNotEmpty) {
      var jsonData =
          convert.jsonDecode(sharedPreferences.getString(vendorGatePas)!);
      vendorGatePassModel =
          vendorGatePassPrefix.VendorGatePassModel.fromJson(jsonData);
      setVendorgatePassData();
    }

    if (journeyStart == True){
      backgroundLocationService?.startLocationFetch();
    }


    }

  imageTextWidget(String svg, String msg, String title) {
    return GestureDetector(
      onTap: () {
        switch (msg) {
          case "Request":
            {
              if(!isLoading){
                requestMethod(title);
              }

            }
            break;
          case "Approve":
            {
              if(!isLoading){
                approvedMethod(title);
              }

            }
            break;
          case "Offline":
            if(!isLoading) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const OfflineLocalConveyance()),
                  (route) => true);
            }
            break;
          case "Daily Report":
            if(!isLoading) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => DailyReport(
                            vendorGatePassLists: vendorGatePassList,
                          )),
                  (route) => true);
            }
            break;
          case "Web Report":
            if(!isLoading)  {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WebReport()),
                  (route) => true);
            }
            break;
          case "Travel Expenses Request":
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => TravelExpensesScreen(
                      ),),
                      (route) => true);
            }
            break;
          case "Close":
          if(!isLoading)
            {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => TaskApproved(
                            pendingTaskList: pendingTaskList,
                            activeemployeeList: activeEmployeeList,
                          )))
                  .then((value) => {getSPArrayList()});
            }
            break;
        }
      },
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: <Widget>[
                Center(
                  child: SvgPicture.asset(
                    svg,
                    width: 50,
                    height: 50,
                  ),
                ),
                badgeWidget(msg, title),
              ],
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

  localConvenceWidget(String svg, String msg, String title) {
    return GestureDetector(
      onTap: () {
        switch (msg) {
          case "Start":
            if(!isLoading)  {

                getCurrentLocation();
                setState(() {
                  isLoading = true;
                });

            }
            break;
          case "End":
            if(!isLoading)   {

                getCurrentLocation();
                setState(() {
                  isLoading = true;
                });

            }
            break;
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: loadSvg(msg, svg),
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

  badgeWidget(String msg, String title) {
    if (title == "Leave") {
      return Visibility(
        visible: pendingLeaveList.isEmpty ? false : true,
        child: Positioned(
          left: 30.0,
          bottom: 30.0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.themeColor,
            ),
            width: msg == "Request" ? 0 : 20,
            height: msg == "Request" ? 0 : 20,
            child: Center(
              child: robotoTextWidget(
                  textval: pendingLeaveList.length.toString(),
                  colorval: Colors.white,
                  sizeval: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    }
    if (title == "Official Duty") {
      return Visibility(
        visible: pendindOdList.isEmpty ? false : true,
        child: Positioned(
          left: 30.0,
          bottom: 30.0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.themeColor,
            ),
            width: msg == "Request" ? 0 : 20,
            height: msg == "Request" ? 0 : 20,
            child: Center(
              child: robotoTextWidget(
                  textval: pendindOdList.length.toString(),
                  colorval: Colors.white,
                  sizeval: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    }
    if (title == "Gate Pass") {
      return Visibility(
        visible: gatePassList.isEmpty ? false : true,
        child: Positioned(
          left: 30.0,
          bottom: 30.0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.themeColor,
            ),
            width: msg == "Request" ? 0 : 20,
            height: msg == "Request" ? 0 : 20,
            child: Center(
              child: robotoTextWidget(
                  textval: gatePassList.length.toString(),
                  colorval: Colors.white,
                  sizeval: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    }

    if (title == "Task") {
      return Visibility(
        visible: pendingTaskList.isEmpty ? false : true,
        child: Positioned(
          left: 30.0,
          bottom: 30.0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.themeColor,
            ),
            width: msg == "Request" ? 0 : 20,
            height: msg == "Request" ? 0 : 20,
            child: Center(
              child: robotoTextWidget(
                  textval: pendingTaskList.length.toString(),
                  colorval: Colors.white,
                  sizeval: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    }

    if (title == "Travel Request") {
      return Visibility(
        visible: travelReqList.isEmpty ? false : true,
        child: Positioned(
          left: 30.0,
          bottom: 30.0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.themeColor,
            ),
            width: msg == "Request" ? 0 : 20,
            height: msg == "Request" ? 0 : 20,
            child: Center(
              child: robotoTextWidget(
                  textval: travelReqList.length.toString(),
                  colorval: Colors.white,
                  sizeval: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  loadSvg(String msg, String svg) {
    if (journeyStart == True && msg == start) {
      return Opacity(
        opacity: 0.42,
        child: SvgPicture.asset(
          svg,
          width: 50,
          height: 50,
        ),
      );
    }

    if (journeyStart == False && msg == start) {
      return SvgPicture.asset(
        svg,
        width: 50,
        height: 50,
      );
    }

    if (journeyStart == True && msg == end) {
      return SvgPicture.asset(
        svg,
        width: 50,
        height: 50,
      );
    }

    if (journeyStart == False && msg == end) {
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
    if (mounted) {
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

      if (mounted) {
        setState(() {
          Address =
              '${place.street},  ${place.subAdministrativeArea},  ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
        });
        setState(() {
          isLoading = false;
        });
        showJourneyDialogue();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showJourneyDialogue();
    }
  }

  void showJourneyDialogue() {
    if (journeyStart == False) {

      showDialog(
        context: context,
        builder: (BuildContext context) => startJourneyPopup(context),
      );
    } else {
      getLocalConveyanceData();
    }
  }

  Future<List<Map<String, dynamic>>?> getLocalConveyanceData() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllLocalConveyance();
    setState(() {
      listMap.forEach(
          (map) => localConveyanceList.add(LocalConveyanceModel.fromMap(map)));
      if (localConveyanceList.isNotEmpty) {
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
            calculateDistance(
                localConveyanceList[localConveyanceList.length - 1]);
          } else {
            savedOfflineLocalConvance(
                localConveyanceList[localConveyanceList.length - 1]);
          }
        });
      }
    });
    return null;
  }

  startJourneyPopup(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: robotoTextWidget(
                    textval: appName,
                    colorval: AppColor.themeColor,
                    sizeval: 16,
                    fontWeight: FontWeight.bold),
              ),
              latLongWidget(
                '$latitude  ${latlong!.latitude}',
              ),
              latLongWidget(
                '$longitude  ${latlong!.longitude}',
              ),
              latLongWidget(
                '$address $Address',
              ),
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
                        backgroundLocationService?.startLocationFetch();
                        String currentDate =
                            DateFormat('yyyyMMdd').format(DateTime.now());
                        String currentTime =
                            DateFormat('HHmmss').format(DateTime.now());
                        LocalConveyanceModel localConveyance =
                            LocalConveyanceModel(
                          empId: int.parse(
                              sharedPreferences.getString(userID).toString()),
                          userId: UserID,
                          fromLatitude: latlong!.latitude.toString(),
                          fromLongitude: latlong!.longitude.toString(),
                          toLatitude: '',
                          toLongitude: '',
                          fromAddress: Address,
                          toAddress: '',
                          createDate: currentDate,
                          createTime: currentTime,
                          endDate: '',
                          endTime: '',
                        );

                        String latlng = "via:" + latlong!.latitude.toString() + "," + latlong!.longitude.toString();

                        WayPointsModel waypoints = WayPointsModel(userId: sharedPreferences.getString(userID).toString(),
                            latlng: latlng,
                            createDate: currentDate,
                            createTime: currentTime,
                            endDate: '',
                            endTime: '');

                        setState(() {
                         journeyStart = True;
                         DatabaseHelper.instance
                             .insertWaypoints(waypoints.toMapWithoutId());
                         DatabaseHelper.instance
                             .insertLocalConveyance(localConveyance.toMapWithoutId());
                          Utility().setSharedPreference(
                              FromLatitude, latlong!.latitude.toString());
                         Utility().setSharedPreference(
                             FromLongitude, latlong!.longitude.toString());
                         Utility().setSharedPreference(
                             localConveyanceJourneyStart, True);
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

  stopJourneyPopup(
      BuildContext context,
      distancePrefix.DistanceCalculateModel distanceCalculateModel,
      LocalConveyanceModel localConveyanceList,
      String toLatitud,
      String toLongitud) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: robotoTextWidget(
                            textval: appName,
                            colorval: AppColor.themeColor,
                            sizeval: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      latLongWidget(
                        '$fromLatitude  ${localConveyanceList.fromLatitude}',
                      ),
                      latLongWidget(
                        '$fromLongitude  ${localConveyanceList.fromLongitude}',
                      ),
                      latLongWidget(
                        '$toLatitude  $toLatitud',
                      ),
                      latLongWidget(
                        '$toLongitude  $toLongitud',
                      ),
                      latLongWidget(
                        '$fromAddress ${distanceCalculateModel.routes[0].legs[0].startAddress}',
                      ),
                      latLongWidget(
                        '$toAddress ${distanceCalculateModel.routes[0].legs[0].endAddress}',
                      ),
                      latLongWidget(
                        '$distanceTravelled ${distanceCalculateModel.routes[0].legs[0].distance.text.toString()}',
                      ),
                      travelModeWidget(),
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
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
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
                                Navigator.of(context).pop();
                                Utility()
                                    .checkInternetConnection()
                                    .then((connectionResult) {
                                  if (connectionResult) {

                                    setState(() {
                                      isLoading = true;
                                      syncTravelDataAPI(localConveyanceList,distanceCalculateModel);
                                    });
                                  } else {
                                    Utility().showInSnackBar(
                                        value: checkInternetConnection,
                                        context: context);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.themeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
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
                    ]))));
  }

  travelModeWidget() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: travelModeController,
        style: const TextStyle(
            color: AppColor.themeColor,
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: enterTravelMode,
          hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  latLongWidget(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          robotoTextWidget(
              textval: title,
              colorval: Colors.black,
              sizeval: 12,
              fontWeight: FontWeight.normal),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<void> downloadingData() async {
    setState(() {
      isLoading = true;
    });

    var jsonData;
    var jsonData1,jsonData2;

    dynamic response = await HTTP.get(
        SyncAndroidToSapAPI(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      SyncAndroidToSapResponse androidToSapResponse =
          SyncAndroidToSapResponse.fromJson(jsonData);
      if(mounted) {
        setState(() {
          syncAndroidToSapResponse = androidToSapResponse;
          Utility()
              .setSharedPreference(syncSapResponse, response.body.toString());
          Utility().setSharedPreference(currentDate, formattedDate);
        });
      }
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
      setState(() {
        gatePassList = pendingGatePassResponse.data;
        gatePassResponse = pendingGatePassResponse;
        isLoading = false;
        Utility()
            .setSharedPreference(gatePassDatail, response2.body.toString());
      });
      setgatePassData();
    }

    dynamic response3 = await HTTP.get(
        vendorOpenGatepass(sharedPreferences.getString(userID).toString()));
    if (response3 != null && response3.statusCode == 200) {
      jsonData1 = convert.jsonDecode(response3.body);
      vendorGatePassPrefix.VendorGatePassModel vendorGatePass =
          vendorGatePassPrefix.VendorGatePassModel.fromJson(jsonData1);
      setState(() {
        vendorGatePassList = vendorGatePass.response;
        vendorGatePassModel = vendorGatePass;
        isLoading = false;
        Utility().setSharedPreference(vendorGatePas, response3.body.toString());
      });
      setVendorgatePassData();
    }

    dynamic response4 = await HTTP.get(
        getTravelRequestAPIList(sharedPreferences.getString(userID).toString()));
    if (response4 != null && response4.statusCode == 200) {
      jsonData2 = convert.jsonDecode(response4.body);
      TR.TravelRequestList travelList =
      TR.TravelRequestList.fromJson(jsonData2);
      if(travelList.status.compareTo("true") == 0){
        travelRequestList = travelList;
        travelReqList = travelList.response;
        Utility().setSharedPreference(travelRequest, response4.body.toString());
        setState(() {
          isLoading = false;
        });
      }
      setTravelData();
    }
  }

  void setListData() {
    if (syncAndroidToSapResponse != null) {
      setState(() {
        leaveBalanceList = syncAndroidToSapResponse!.leavebalance;
        leaveBalanceList
            .add(Leavebalance(leaveType: 'WITHOUT PAY-0.0', leaveBal: 999.0));
        activeEmployeeList = syncAndroidToSapResponse!.activeemployee;
        attendenceList = syncAndroidToSapResponse!.attendanceemp;
        odEmpList = syncAndroidToSapResponse!.odemp;
        leaveEmpList = syncAndroidToSapResponse!.leaveemp;
        pendingTaskList = syncAndroidToSapResponse!.pendingtask;
        pendingLeaveList = syncAndroidToSapResponse!.pendingleave;
        pendindOdList = syncAndroidToSapResponse!.pendingod;
      });

      print("DataUpdate=======>true");
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
      print("DataUpdate2=======>true");
    }
  }

  void setVendorgatePassData() {
    if (vendorGatePassModel != null &&
        vendorGatePassModel!.response.isNotEmpty) {
      setState(() {
        vendorGatePassList = vendorGatePassModel!.response;
      });
    }
  }

  void setTravelData() {
    if (travelRequestList != null &&
        travelRequestList!.response.isNotEmpty) {
      setState(() {
        travelReqList = travelRequestList!.response;
      });
    }
  }

  void requestMethod(String title) {
    switch (title) {
      case "Leave":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => LeaveRequestScreen(
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
                  builder: (context) => OfficialRequest(
                        activeemployeeList: activeEmployeeList,
                      )),
              (route) => true);
        }
        break;
      case "Gate Pass":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => GatepassRequestScreen(
                        activeemployeeList: activeEmployeeList,
                      )),
              (route) => true);
        }
        break;
      case "Task":
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => TaskRequestScreen(
                        activeemployeeList: activeEmployeeList,
                      )),
              (route) => true);
        }
        break;

      case "Travel Request":
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => TravelRequestScreen(

                )),
                (route) => true);
        break;
    }
  }

  void approvedMethod(String title) {
    switch (title) {
      case "Leave":
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => LeaveApproved(
                        pendingLeaveList: pendingLeaveList,
                      )))
              .then((value) => {getSPArrayList()});
        }
        break;
      case "Official Duty":
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      OfficialApproved(pendindOdList: pendindOdList)))
              .then((value) => {getSPArrayList()});
        }
        break;
      case "Gate Pass":
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      GatePassApproved(gatePassList: gatePassList)))
              .then((value) => {getSPArrayList()});
        }
        break;
      case "Travel Request":
        {

          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) =>
                  TravelApproved(allTravelReqList: travelReqList, )))
              .then((value) => {getSPArrayList()});
        }
        break;
    }
  }

  Future<void> calculateDistance(
      LocalConveyanceModel localConveyanceList) async {

    List<WayPointsModel> wayPointList = [];
    List<LocalConveyanceModel> localConveyanceList = [];

    List<Map<String, dynamic>> listMap =
    await DatabaseHelper.instance.queryAllLocalConveyance();
    listMap.forEach(
            (map) => localConveyanceList.add(LocalConveyanceModel.fromMap(map)));
    if (localConveyanceList.isNotEmpty) {
      List<Map<String, dynamic>> listMap =
      await DatabaseHelper.instance.queryAllWaypoints(
          localConveyanceList[localConveyanceList.length - 1]
              .toMapWithoutId());

      listMap.forEach(
              (map) => wayPointList.add(WayPointsModel.fromMap(map)));

     print('wayPointList======>${wayPointList[wayPointList.length - 1].latlng}');

      String waypoints =wayPointList[wayPointList.length - 1].latlng;

      List<String> list = waypoints.split("|");

      print('list====>${list.toString()}');

      print('list_length====>${list.length}');

      if(list.length>20){
        double  position = list.length/15;
        int pos = position.round();
        print("position=====>$position");
        print("position2222=====>${position.round()}");


        for (int i = 0; i <= list.length; i++) {
          if (i != 0 && i != list.length - 1) {
            if (totalWayPoints.isEmpty) {

              totalWayPoints = list[pos * i];
              print('positi====>${i}======>${list[pos * i]}');
            } else {
              if (pos * i < list.length) {
                if (!totalWayPoints.contains(list[pos * i])) {
                  totalWayPoints = totalWayPoints + "|" + list[pos * i];
                  print('positi====>${i}======>${list[pos * i]}');
                }
              }
            }
          }
        }

      }else {
        for (int i = 0; i <= list.length; i++) {
          if (totalWayPoints.isEmpty) {
            totalWayPoints = list[i];
          } else {
            if (i < list.length) {
              if (!totalWayPoints.contains(list[i])) {
                totalWayPoints = totalWayPoints + "|" + list[i];
              }
            }
          }
        }
      }
      print('totalWayPoints======>${totalWayPoints.toString()}');

      var jsonData;
      String toLatitude = latlong!.latitude.toString();
      String toLongitude = latlong!.longitude.toString();
      dynamic response = await HTTP.get(getDistanceAPI(
          '${localConveyanceList[localConveyanceList.length-1].fromLatitude},'
              '${localConveyanceList[localConveyanceList.length-1].fromLongitude}',
          '$toLatitude,$toLongitude','${totalWayPoints.toString()}'));
      if (response != null && response.statusCode == 200) {
        jsonData = convert.jsonDecode(response.body);
        print('jsonData=====>$jsonData');
        distancePrefix.DistanceCalculateModel distanceCalculateModel =
        distancePrefix.DistanceCalculateModel.fromJson(jsonData);
        if (distanceCalculateModel.routes.isNotEmpty &&
            distanceCalculateModel.routes[0].legs.isNotEmpty &&
            distanceCalculateModel.routes[0].legs[0].distance.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) => stopJourneyPopup(
                context,
                distanceCalculateModel,
                localConveyanceList[localConveyanceList.length-1],
                toLatitude,
                toLongitude),
          );
        }
      }

    }}

  Future<void> syncTravelDataAPI(
    LocalConveyanceModel LocalConveyance,
    distancePrefix.DistanceCalculateModel distanceCalculateModel,
  ) async {


    String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
    String currentTime = DateFormat('HHmmss').format(DateTime.now());

    totalWayPoints = totalWayPoints.replaceAll("via:", "");


    allLatLng = '${LocalConveyance.fromLatitude},'
        '${LocalConveyance.fromLongitude},'
        '${LocalConveyance.toLatitude},'
        '${LocalConveyance.toLongitude}';
    travelList.add(TravelModel(
        pernr: LocalConveyance.userId.toString(),
        begda: LocalConveyance.createDate,
        endda: currentDate,
        startTime: LocalConveyance.createTime,
        endTime: currentTime,
        startLat: LocalConveyance.fromLatitude,
        endLat: latlong!.latitude.toString(),
        startLong: LocalConveyance.fromLongitude,
        endLong: latlong!.longitude.toString(),
        latLong111: totalWayPoints,
        startLocation: distanceCalculateModel.routes[0].legs[0].startAddress,
        endLocation: distanceCalculateModel.routes[0].legs[0].endAddress,
        distance: distanceCalculateModel.routes[0].legs[0].distance.text,
        travelMode: travelModeController.text.toString(),
        latLong: allLatLng));
    String value = convert.jsonEncode(travelList).toString();
    var jsonData;
    dynamic response = await HTTP.get(syncLocalConveyanceAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);

      print('jsonData=====>$jsonData');
      setState(() {
        backgroundLocationService?.stopLocationFetch();
        journeyStart = False;
        Utility().setSharedPreference(localConveyanceJourneyStart, False);
        DatabaseHelper.instance
            .deleteLocalConveyance(LocalConveyance.toMapWithoutId());
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        Utility().showInSnackBar(value: somethingWentWrong, context: context);
      });
    }
  }


  Future<void> savedOfflineLocalConvance(LocalConveyanceModel localConveyanceList) async {
    String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
    String currentTime = DateFormat('HHmmss').format(DateTime.now());



    List<Map<String, dynamic>> listMap =
    await DatabaseHelper.instance.queryAllWaypoints(
        localConveyanceList.toMapWithoutId());

    listMap.forEach(
            (map) => wayPointList.add(WayPointsModel.fromMap(map)));


    LocalConveyanceModel localConveyance = LocalConveyanceModel(
        empId: int.parse(sharedPreferences.getString(userID).toString()),
        userId: UserID,
        fromLatitude: localConveyanceList.fromLatitude,
        fromLongitude: localConveyanceList.fromLongitude,
        toLatitude: latlong!.latitude.toString(),
        toLongitude: latlong!.longitude.toString(),
        fromAddress: localConveyanceList.fromAddress,
        toAddress:  '',
        createDate: localConveyanceList.createDate,
        createTime: localConveyanceList.createTime,
        endDate: currentDate,
        endTime: currentTime);

    WayPointsModel waypoints = WayPointsModel(
        userId: sharedPreferences.getString(userID).toString(),
        latlng: wayPointList[wayPointList.length - 1].latlng,
        createDate: wayPointList[wayPointList.length - 1].createDate,
        createTime: wayPointList[wayPointList.length - 1].createTime,
        endDate: currentDate,
        endTime: currentTime);

    setState(() {
      journeyStart = False;
      Utility().setSharedPreference(localConveyanceJourneyStart, False);
      Utility().showInSnackBar(value: dataSavedOffline, context: context);
      DatabaseHelper.instance.updateLocalConveyance(localConveyance.toMapWithoutId());
      DatabaseHelper.instance.updateWaypoints(waypoints.toMapWithoutId());

    });
  }
}
