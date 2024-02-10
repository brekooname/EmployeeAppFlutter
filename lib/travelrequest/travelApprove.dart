// ignore_for_file: must_be_immutable
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/travelrequest/model/approveStatus.dart';
import 'package:shakti_employee_app/travelrequest/model/travelrequestlist.dart'
    as TR;
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shakti_employee_app/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/firestore_appupdate_notifier.dart';
import '../theme/string.dart';
import '../uiwidget/appupdatewidget.dart';

class TravelApproved extends StatefulWidget {
  TravelApproved({Key? key, required this.allTravelReqList}) : super(key: key);
  List<TR.Response> allTravelReqList = [];

  @override
  State<TravelApproved> createState() => _TravelApprovedState();
}

class _TravelApprovedState extends State<TravelApproved> {
  List<TR.Response> travelReqList = [];
  late SharedPreferences sharedPreferences;
  late int selectedIndex;
  bool isDataLoading = false, isLoading = false, isEmployeeApp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    travelReqList = widget.allTravelReqList;
    Init();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        appUrl: value.fireStoreData!.employeeAppUrl.toString(),
                      )),
              (Route<dynamic> route) => false);
        });
      } else {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: AppColor.themeColor,
              title: robotoTextWidget(
                  textval: TravelApprove,
                  colorval: AppColor.whiteColor,
                  sizeval: 16,
                  fontWeight: FontWeight.w600),
            ),
            body: Stack(
              children: [
                _buildPosts(context),
                Center(
                  child: isDataLoading == true
                      ? const CircularProgressIndicator(
                          color: Colors.indigo,
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildPosts(BuildContext context) {
    if (travelReqList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: travelReqList.length,
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
                        detailWidget(
                            docNo, travelReqList[index].docno.toString()),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(nametxt, travelReqList[index].empName),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            datedetailWidget(
                                dateFrom, travelReqList[index].travelDateFrom),
                            const SizedBox(
                              width: 4,
                            ),
                            datedetailWidget(
                                dateTo, travelReqList[index].travelDateTo),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            datedetailWidget(
                                from, travelReqList[index].travelFrom),
                            const SizedBox(
                              width: 4,
                            ),
                            datedetailWidget(to, travelReqList[index].travelTo),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        detailWidget(remarktxt, travelReqList[index].suggested),
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
                                            travelReqList[index].docno,
                                            travelReqList[index].pernr,
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
                                            travelReqList[index].docno,
                                            travelReqList[index].pernr,
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

  Widget dialogue_removeDevice(
      BuildContext context, String docNo, String sapCode, int i) {
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
            i == 0 ? travelReject : travelConfirmation,
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
                          rejectTravel(docNo, sapCode);
                        } else {
                          confirmTravel(docNo, sapCode);
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

  detailWidget(String title, String value) {
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

  Future<void> confirmTravel(String docNo, String sapCode) async {
    setState(() {
      isLoading = true;
    });

    dynamic response = await HTTP.get(sendTravelRequestStatus(
        docNo, sharedPreferences.getString(userID).toString(), sapCode, "A"));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      ApproveStatusResponse approveStatusResponse =
          ApproveStatusResponse.fromJson(jsonData);

      if (approveStatusResponse.status.compareTo("true") == 0) {
        updateSharedPreference("0", approveStatusResponse.message);
        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showInSnackBar(
            value: approveStatusResponse.message, context: context);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showToast(somethingWentWrong);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> rejectTravel(String docNo, String sapCode) async {
    setState(() {
      isLoading = true;
    });

    dynamic response = await HTTP.get(sendTravelRequestStatus(
        docNo, sharedPreferences.getString(userID).toString(), sapCode, "R"));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      ApproveStatusResponse approveStatusResponse =
          ApproveStatusResponse.fromJson(jsonData);

      if (approveStatusResponse.status.compareTo("true") == 0) {
        updateSharedPreference("1", approveStatusResponse.message);

        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showInSnackBar(
            value: approveStatusResponse.message, context: context);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showToast(somethingWentWrong);
      setState(() {
        isLoading = false;
      });
    }
  }

  updateSharedPreference(String value, String mess) async {
    dynamic response = await HTTP.get(getTravelRequestAPIList(
        sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      setState(() {
        isLoading = false;
        Utility().setSharedPreference(travelRequest, response.body.toString());
      });

      if (value == "0") {
        Utility().showToast(travelConfrimed);
      } else {
        Utility().showToast(travelRejectSucc);
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
