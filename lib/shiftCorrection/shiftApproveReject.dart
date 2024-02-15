// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/shiftCorrection/model/shiftApproveRequest.dart';
import 'package:shakti_employee_app/shiftCorrection/model/shiftdatalistModel.dart' as ShiftData;
import 'package:shakti_employee_app/shiftCorrection/model/shiftsaveresposne.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/string.dart';
import '../provider/firestore_appupdate_notifier.dart';
import '../theme/color.dart';
import '../uiwidget/appupdatewidget.dart';
import '../webservice/constant.dart';

class ShiftApproved extends StatefulWidget {
  List<ShiftData.Response> shiftList = [];

  ShiftApproved({Key? key, required this.shiftList}) : super(key: key);

  @override
  State<ShiftApproved> createState() => _ShiftApprovedState();
}

class _ShiftApprovedState extends State<ShiftApproved> {
  bool isLoading = false;
  late int selectedIndex;
  String rejectStatus = 'reject', approveStatus = 'approve';
  late SharedPreferences sharedPreferences;
  String dateTimeOldFormat = 'dd.MM.yyyy HH:mm:SS',
      dateTimeNewFormat = "dd MMM yyyy HH:mm a";
  bool isEmployeeApp = false;
  List<ShiftDataRequestModel> shiftRequestList = [];
  
  
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
                    textval: shiftC,
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
    if (widget.shiftList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: widget.shiftList.length,
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
                    detailWidget(nametxt, widget.shiftList[index].ename),
                    detailWidget(
                        selectShiftType, widget.shiftList[index].shift +"    "+  widget.shiftList[index].shftInnTime + " to "+ widget.shiftList[index].shftOutTime),
                    detailWidget(
                        datetxt, widget.shiftList[index].begda.toString()),
                    detailWidget(remarktxt, widget.shiftList[index].remarkEmp),
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
                                    dialogue_removeShift(
                                        context,selectedIndex, 0),
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
                                    dialogue_removeShift(
                                        context,
                                        selectedIndex,
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

  Widget dialogue_removeShift(
      BuildContext context, int pos, int i) {
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
            i == 0 ? shfitReject : shfitConfirmation,
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
                        sendShiftApproveAPI(pos,i);
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



  Future<void> sendShiftApproveAPI(int pos, int i) async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    shiftRequestList.clear();
    shiftRequestList.add(ShiftDataRequestModel(
        docno: widget.shiftList[pos].docno, 
        hod: "285",
        pernr: widget.shiftList[pos].pernr,
        begda: Utility.convertDateFormat(
            widget.shiftList[pos].begda, "dd.MM.yyyy", "yyyyMMdd"),
        shift:widget.shiftList[pos].shift,
        shftInnTime: Utility.convertDateFormat(widget.shiftList[pos].shftInnTime, "hh:mm:ss", "hhmmss"),
        shftOutTime:Utility.convertDateFormat(widget.shiftList[pos].shftOutTime, "hh:mm:ss", "hhmmss"),
        remarkEmp: widget.shiftList[pos].remarkEmp,
        hodApp: i == 0 ?"Y":"X",
        appBy: sharedPreferences.getString(userID).toString()));

    String value = convert.jsonEncode(shiftRequestList).toString();
    print("Parameter Value===>${value.toString()}");

    dynamic response = await HTTP.get(shiftApproveAPI(value));
    if (response != null && response.statusCode == 200) {
     var jsonData = convert.jsonDecode(response.body);
      ShiftResponseModel shiftResponseModel =
      ShiftResponseModel.fromJson(jsonData);
     if (shiftResponseModel.status == "true") {

       updateSharedPreference(i == 0 ?rejectStatus:approveStatus,pos );

       setState(() {
         isLoading = false;
       });
     } else {
       Utility().showToast(shiftResponseModel.message);
       setState(() {
         isLoading = false;
       });
     }

    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  updateSharedPreference(String value, int pos) async {
    dynamic response = await HTTP
        .get(pendingShiftData(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      setState(() {
        isLoading = false;
        Utility().setSharedPreference(shiftDetail, response.body.toString());
      });

      if (value == approveStatus) {
        Utility().showToast(shiftSuccess);
      } else if (value == rejectStatus) {
        Utility().showToast(shiftPassSuccess);
      }

      widget.shiftList.removeAt(pos);

    } else {
      setState(() {
        isLoading = false;
      });
      Utility().showToast(somethingWentWrong);
    }
  }


}
