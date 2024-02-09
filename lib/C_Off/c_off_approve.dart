import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/C_Off/model/coffApproveList.dart' as CO;
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../provider/firestore_appupdate_notifier.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/appupdatewidget.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/constant.dart';

class coffApproveWidget extends StatefulWidget {
  List<CO.Response> cOffApprovalList = [];

  coffApproveWidget({Key? key, required this.cOffApprovalList})
      : super(key: key);

  @override
  State<coffApproveWidget> createState() => _coffApproveWidgetState();
}

class _coffApproveWidgetState extends State<coffApproveWidget> {
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
    // TODO: implement build
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
                textval: cOffApprove,
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
    if (widget.cOffApprovalList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: widget.cOffApprovalList.length,
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
                    detailWidget(nametxt, widget.cOffApprovalList[index].appBy),
                    detailWidget(
                        leaveType, widget.cOffApprovalList[index].appBy),
                    detailWidget(
                        applyDate, widget.cOffApprovalList[index].applyDate),
                    
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
                            //  selectedIndex = index;
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) =>
                              //       dialogue_removeCoffData(
                              //           context,
                              //           widget.hodApprovalList[index],
                              //           widget.hodApprovalList[index].gpno,
                              //           0),
                              // );
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
                            //  selectedIndex = index;
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) =>
                              //       dialogue_removeCoffData(
                              //           context,
                              //           widget.hodApprovalList[index].pernr,
                              //           widget.hodApprovalList[index].gpno,
                              //           1),
                              // );
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

  Widget dialogue_removeCoffData(
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
            i == 0 ? cOffReject : cOffConfirmation,
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
                        // API Call for reject and approve
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
}
