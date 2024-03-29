// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/gatepass/model/PendingGatePassResponse.dart';
import 'package:shakti_employee_app/gatepass/model/gatePassResponse.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/string.dart';
import '../provider/firestore_appupdate_notifier.dart';
import '../theme/color.dart';
import '../uiwidget/appupdatewidget.dart';
import '../webservice/constant.dart';

class GatePassApproved extends StatefulWidget {
  List<Datum> gatePassList = [];

  GatePassApproved({Key? key, required this.gatePassList}) : super(key: key);

  @override
  State<GatePassApproved> createState() => _GatePassApprovedState();
}

class _GatePassApprovedState extends State<GatePassApproved> {
  bool isLoading = false;
  late int selectedIndex;
  String rejectStatus = 'reject', approveStatus = 'approve';
  late SharedPreferences sharedPreferences;
  String dateTimeOldFormat = 'dd.MM.yyyy HH:mm:SS',
      dateTimeNewFormat = "dd MMM yyyy HH:mm a";
  bool isEmployeeApp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColor.themeColor,
            title: robotoTextWidget(
                textval: gatePassApprove,
                colorval: AppColor.whiteColor,
                sizeval: 16,
                fontWeight: FontWeight.w600),
          ),
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
    if (widget.gatePassList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: widget.gatePassList.length,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailWidget(
                        gatePassNo, widget.gatePassList[index].gpno.toString()),
                    detailWidget(nametxt, widget.gatePassList[index].ename),
                    detailWidget(
                        gatePassType, widget.gatePassList[index].gptypeTxt),
                    detailWidget(
                        requiredType, widget.gatePassList[index].reqtypeTxt),
                    datedetailWidget(
                        from,
                        Utility.convertDateFormat(
                            '${widget.gatePassList[index].gpdat.toString()} ${widget.gatePassList[index].gptime.toString()}',
                            dateTimeOldFormat,
                            dateTimeNewFormat)),
                    widget.gatePassList[index].eindat.toString() !=
                                '00.00.0000' &&
                            widget.gatePassList[index].eintime.toString() !=
                                '00:00:00'
                        ? datedetailWidget(
                            to,
                            Utility.convertDateFormat(
                                '${widget.gatePassList[index].eindat.toString()} '
                                '${widget.gatePassList[index].eintime.toString()}',
                                dateTimeOldFormat,
                                dateTimeNewFormat))
                        : Container(),
                    detailWidget(visitPlace, widget.gatePassList[index].vplace),
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
                                        widget.gatePassList[index].pernr,
                                        widget.gatePassList[index].gpno,
                                        0),
                              );
                            },
                            child:
                                IconWidget('assets/svg/delete.svg', rejecttxt),
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
                                        widget.gatePassList[index].pernr,
                                        widget.gatePassList[index].gpno,
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
              ]))),
    ]);
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
      width: MediaQuery.of(context).size.width,
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

  detailWidget(String title, var value) {
    return Container(
      margin: EdgeInsets.only(top: 2),
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

  Widget dialogue_removeDevice(
      BuildContext context, var perner, var leaveNo, int i) {
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
            i == 0 ? gatePassReject : gatePassConfirmation,
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
                          confirmGatePass(perner, leaveNo, rejectStatus);
                        } else {
                          confirmGatePass(perner, leaveNo, approveStatus);
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

  Future<void> confirmGatePass(
      String prner, String leaveNo, String status) async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic response = await HTTP.get(approveGatePassAPI(prner, leaveNo,
        sharedPreferences.getString(userID).toString(), status));
    if (response != null && response.statusCode == 200) {
      Iterable l = convert.json.decode(response.body);
      List<GatePassResponse> gatePassResponse = List<GatePassResponse>.from(
          l.map((model) => GatePassResponse.fromJson(model)));

      if (gatePassResponse[0].msgtyp.compareTo("S") == 0) {
        updateSharedPreference(status);
      } else {
        setState(() {
          isLoading = false;
        });
        Utility().showToast(gatePassResponse[0].text);
      }
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  updateSharedPreference(String value) async {
    dynamic response = await HTTP
        .get(pendingGatePass(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      setState(() {
        isLoading = false;
        Utility().setSharedPreference(gatePassDatail, response.body.toString());
      });

      if (status == approveStatus) {
        Utility().showToast(gatePassSuccess);
      } else if (status == rejectStatus) {
        Utility().showToast(gateRejectPassSuccess);
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
