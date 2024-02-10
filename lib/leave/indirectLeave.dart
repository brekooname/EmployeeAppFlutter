import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/leave/model/leaveResponse.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/string.dart';
import '../provider/firestore_appupdate_notifier.dart';
import '../uiwidget/appupdatewidget.dart';
import '../webservice/constant.dart';
import 'model/leaverejectResponse.dart';

class InDirectLeave extends StatefulWidget {
  String Status;
  List<Pendingleave> pendindLeaveList = [];

  InDirectLeave(
      {Key? key, required this.Status, required this.pendindLeaveList})
      : super(key: key);

  @override
  State<InDirectLeave> createState() => InDirectLeaveState();
}

class InDirectLeaveState extends State<InDirectLeave> {
  bool isLoading = false;
  late int selectedIndex;
  late SharedPreferences sharedPreferences;
  bool isEmployeeApp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<firestoreAppUpdateNofifier>(
        builder: (context, value, child) {
      isEmployeeApp = value.isEmployeeApp;
      if (value.fireStoreData != null &&
          value.fireStoreData!.minEmployeeAppVersion != value.appVersionCode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utility().clearSharedPreference();
          Utility().deleteDatabase(databaseName);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => AppUpdateWidget(
                      appUrl: value.fireStoreData!.employeeAppUrl.toString())),
              (Route<dynamic> route) => false);
        });
      } else {
        return Scaffold(
          body: Stack(
            children: [
              _buildPosts(context),
              Center(
                child: isLoading == true
                    ? const CircularProgressIndicator(
                        color: Colors.indigo,
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildPosts(BuildContext context) {
    if (widget.pendindLeaveList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: widget.pendindLeaveList.length,
        padding: const EdgeInsets.all(5),
      ),
    );
  }

  Wrap ListItem(int index) {
    return Wrap(children: [
      Card(
          elevation: 10,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.greyBorder,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
              width: 400,
              color: AppColor.whiteColor,
              padding: const EdgeInsets.all(5),
              child: Stack(children: <Widget>[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailWidget(leaveNo,
                            widget.pendindLeaveList[index].leavNo.toString()),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(
                            nametxt, widget.pendindLeaveList[index].name),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(
                            leaveType,
                            widget.pendindLeaveList[index].horo +
                                widget.pendindLeaveList[index].dedQuta1),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            datedetailWidget(leaveFrom,
                                widget.pendindLeaveList[index].levFr),
                            const SizedBox(
                              width: 4,
                            ),
                            datedetailWidget(
                                leaveTo, widget.pendindLeaveList[index].levT),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(
                            visitPlace, widget.pendindLeaveList[index].reason),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 40,
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                onTap: () {
                                  selectedIndex = index;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        dialogue_removeDevice(
                                            context,
                                            widget
                                                .pendindLeaveList[index].leavNo,
                                            0),
                                  );
                                },
                                child: IconWidget(
                                    'assets/svg/delete.svg', rejecttxt),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 40,
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                onTap: () {
                                  selectedIndex = index;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        dialogue_removeDevice(
                                            context,
                                            widget
                                                .pendindLeaveList[index].leavNo,
                                            1),
                                  );
                                },
                                child: IconWidget(
                                    'assets/svg/checkmark.svg', approvetxt),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ]))),
    ]);
  }

  Row IconWidget(String svg, String txt) {
    return Row(
      children: [
        SvgPicture.asset(
          svg,
          width: 32,
          height: 32,
        ),
        const SizedBox(
          width: 5,
        ),
        robotoTextWidget(
            textval: txt,
            colorval: Colors.black,
            sizeval: 16,
            fontWeight: FontWeight.w600)
      ],
    );
  }

  Widget dialogue_removeDevice(BuildContext context, var leaveNo, int i) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              isEmployeeApp ? appName : appName2,
              style: const TextStyle(
                  color: AppColor.themeColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            i == 0 ? leaveReject : leaveConfirmation,
            style: const TextStyle(
                color: AppColor.themeColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 12),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    backgroundColor: AppColor.whiteColor,
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
                    Navigator.pop(context);
                    Utility()
                        .checkInternetConnection()
                        .then((connectionResult) {
                      if (connectionResult) {
                        if (i == 0) {
                          rejectLeave(leaveNo);
                        } else {
                          confirmLeave(leaveNo);
                        }
                      } else {
                        Utility().showInSnackBar(
                            value: checkInternetConnection, context: context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.themeColor,
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
        ]));
  }

  detailWidget(String title, var value) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      height: 26,
      child: Row(
        children: [
          robotoTextWidget(
            textval: title,
            colorval: AppColor.blackColor,
            sizeval: 14.0,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            width: 10,
          ),
          robotoTextWidget(
            textval: value,
            colorval: AppColor.themeColor,
            sizeval: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  SizedBox NoDataFound() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(30, 136, 229, .5),
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ]),
            child: Align(
              alignment: Alignment.center,
              child: robotoTextWidget(
                  textval: noDataFound,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  datedetailWidget(String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.2,
      height: 30,
      child: Row(
        children: [
          robotoTextWidget(
            textval: title,
            colorval: AppColor.blackColor,
            sizeval: 14.0,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            width: 10,
          ),
          robotoTextWidget(
            textval: value,
            colorval: AppColor.themeColor,
            sizeval: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Future<void> Init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> confirmLeave(int leaveNo) async {
    setState(() {
      isLoading = true;
    });

    dynamic response = await HTTP.get(approveLeaveAPI(
        leaveNo,
        sharedPreferences.getString(userID).toString(),
        sharedPreferences.getString(password).toString()));
    if (response != null && response.statusCode == 200) {
      Iterable l = convert.json.decode(response.body);
      List<LeaveApproveResponse> leaveResponse =
          List<LeaveApproveResponse>.from(
              l.map((model) => LeaveApproveResponse.fromJson(model)));

      if (leaveResponse[0].type.compareTo("S") == 0) {
        updateSharedPreference("0");
      } else {
        Utility().showToast(leaveResponse[0].msg);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> rejectLeave(int leaveNo) async {
    setState(() {
      isLoading = true;
    });

    dynamic response = await HTTP.get(rejectLeaveAPI(
        leaveNo,
        sharedPreferences.getString(userID).toString(),
        sharedPreferences.getString(password).toString()));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      LeaveRejectResponse leaveResponse =
          LeaveRejectResponse.fromJson(jsonData);
      if (leaveResponse.status.compareTo("true") == 0) {
        updateSharedPreference("1");
      } else {
        setState(() {
          isLoading = false;
        });

        Utility().showToast(leaveResponse.message);
      }
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  updateSharedPreference(String value) async {
    dynamic response = await HTTP.get(
        SyncAndroidToSapAPI(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      if (mounted) {
        setState(() {
          isLoading = false;
          Utility()
              .setSharedPreference(syncSapResponse, response.body.toString());
        });
      }

      if (value == "0") {
        Utility().showToast(leaveASuccessfully);
      } else {
        Utility().showToast(leaveRejectSuccessfully);
      }
      Navigator.of(context).pop();
    } else {
      setState(() {
        isLoading = false;
      });
      Utility().showToast(somethingWentWrong);
    }
  }
}
