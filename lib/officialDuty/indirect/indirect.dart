import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/officialDuty/model/odApproveResponse.dart';
import 'package:shakti_employee_app/officialDuty/model/odRejectResponse.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/firestore_appupdate_notifier.dart';
import '../../theme/string.dart';
import 'dart:convert' as convert;
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import '../../uiwidget/appupdatewidget.dart';
import '../../webservice/constant.dart';

class InDirect extends StatefulWidget {
  String Status;
  List<Pendingod> pendindOdList = [];

  InDirect({Key? key, required this.Status, required this.pendindOdList})
      : super(key: key);

  @override
  State<InDirect> createState() => InDirectState();
}

class InDirectState extends State<InDirect> {
  bool isLoading = false;
  late int selectedIndex;
  late SharedPreferences sharedPreferences;
  bool isEmployeeApp=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<firestoreAppUpdateNofifier>(
        builder: (context, value, child) {
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
      } return Container(
      );
        });
  }

  Widget _buildPosts(BuildContext context) {
    if (widget.pendindOdList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: widget.pendindOdList.length,
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
                        detailWidget(docNo, widget.pendindOdList[index].odno),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(
                            nametxt, widget.pendindOdList[index].ename),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            datedetailWidget(
                                odStart, widget.pendindOdList[index].odstdateC),
                            const SizedBox(
                              width: 4,
                            ),
                            datedetailWidget(
                                odEnd, widget.pendindOdList[index].odedateC),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(
                            visitPlace, widget.pendindOdList[index].vplace),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(
                            visitPurpose, widget.pendindOdList[index].purpose1),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(noOfDay, widget.pendindOdList[index].horo),
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
                                            widget.pendindOdList[index].odno,
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
                                            widget.pendindOdList[index].odno,
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

  Widget dialogue_removeDevice(BuildContext context, String odno, var status) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              isEmployeeApp?appName:appName2,
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
            status == 0 ? reject : confirmation,
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
                    Navigator.of(context).pop();

                    Utility().checkInternetConnection().then((connectionResult) {
                      if (connectionResult) {
                        if (status == 0) {
                          rejectOD(odno);
                        } else {
                          confirmOD(odno);
                        }
                      } else {
                        Utility()
                            .showInSnackBar(value: checkInternetConnection, context: context);
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

  detailWidget(String title, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
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
        )));
  }

  datedetailWidget(String title, String value) {
    return SizedBox(
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

  Future<void> confirmOD(String odno) async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic response = await HTTP.get(approveODAPI(
        odno,
        sharedPreferences.getString(userID).toString(),
        sharedPreferences.getString(password).toString()));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      OdApproveResponse odResponse = OdApproveResponse.fromJson(jsonData);

      print('odResponse  ${odResponse.toString()}');

      if (odResponse.odStatus[0].type.compareTo("S") == 0) {
        updateSharedPreference("0");
      } else {
        setState(() {
          isLoading = false;
        });
        Utility().showToast(odResponse.odStatus[0].msg);
      }
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  Future<void> rejectOD(String odno) async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic response = await HTTP.get(rejectODAPI(
        odno,
        sharedPreferences.getString(userID) as String,
        sharedPreferences.getString(password) as String));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      OdRejectResponse odResponse = OdRejectResponse.fromJson(jsonData);

      if (odResponse.status.compareTo("true") == 0) {
        updateSharedPreference("1");
      } else {
        setState(() {
          isLoading = false;
        });
        Utility().showToast(odResponse.message);
      }
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  updateSharedPreference(String value) async {
    dynamic response = await HTTP.get(
        SyncAndroidToSapAPI(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      setState(() {
        isLoading = false;
        Utility()
            .setSharedPreference(syncSapResponse, response.body.toString());
      });

      if (value == "0") {
        Utility().showToast(odApprovedSuccess);
      } else {
        Utility().showToast(odRejectSuccess);
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
