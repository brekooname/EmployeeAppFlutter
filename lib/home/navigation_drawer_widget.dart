import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/all_task/my_task_list.dart';
import 'package:shakti_employee_app/sidemenu/travelReport/travelreport.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

import '../main.dart';
import '../sidemenu/attendance/attendanceReport.dart';
import '../sidemenu/leavereport/LeaveReport.dart';
import '../sidemenu/officaldutyreport/officialdutyReport.dart';
import '../sidemenu/personalinfo/personalinfo.dart';
import '../sidemenu/salaryslip/salaryslip.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../webservice/constant.dart';
import 'model/ScyncAndroidtoSAP.dart';
import 'model/personalindoresponse.dart';

class NavigationDrawerWidget extends StatefulWidget {
  NavigationDrawerWidget(
      {Key? key,
      required this.name,
      required this.attendenceList,
      required this.leaveEmpList,
      required this.odEmpList,
      required this.personalInfo})
      : super(key: key);
  String name;

  List<Attendanceemp> attendenceList = [];
  List<Leaveemp> leaveEmpList = [];
  List<Odemp> odEmpList = [];
  List<Emp> personalInfo = [];

  @override
  State<NavigationDrawerWidget> createState() => _HomePageState();
}

class _HomePageState extends State<NavigationDrawerWidget> {

  String  appVersion = "";
  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: robotoTextWidget(
                  textval: widget.name,
                  colorval: AppColor.whiteColor,
                  sizeval: 14,
                  fontWeight: FontWeight.w600),
              accountEmail:  robotoTextWidget(
                  textval: appVersion!,
                  colorval: AppColor.whiteColor,
                  sizeval: 12,
                  fontWeight: FontWeight.w600),
              decoration: const BoxDecoration(
                color: AppColor.themeColor,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColor.whiteColor,
                child: widget.name.isNotEmpty?robotoTextWidget(
                    textval: widget.name[0],
                    colorval: AppColor.themeColor,
                    sizeval: 22,
                    fontWeight: FontWeight.w600):Container(),
              ),
            ),
            navigationItemWidget(0, Icons.home, hometxt),
            navigationItemWidget(1, Icons.task, myTask),
            navigationItemWidget(2, Icons.calendar_month, attendance),
            navigationItemWidget(3, Icons.calendar_today_rounded, leave),
            navigationItemWidget(4, Icons.person_outline_rounded, officialDuty),
            navigationItemWidget(5, Icons.route_outlined, travelReport),
            navigationItemWidget(6, Icons.person_outline_rounded, payslip),
            navigationItemWidget(7, Icons.person, personalInfo),
            navigationItemWidget(8, Icons.logout, logout),
          ],
        ));
  }

  navigationItemWidget(int position, IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColor.themeColor,
      ),
      title: robotoTextWidget(
          textval: title,
          colorval: AppColor.blackColor,
          sizeval: 12,
          fontWeight: FontWeight.bold),
      onTap: () {
        switch (position) {
          case 0:
            {
              Navigator.pop(context);
            }
            break;

          case 1:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => MyTaskListWidget()),
                      (route) => true);
            }
            break;

          case 2:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => AttendanceReport(
                            attendenceList: widget.attendenceList,
                          )),
                  (route) => true);
            }
            break;
          case 3:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => LeaveReport(
                            leaveEmpList: widget.leaveEmpList,
                          )),
                  (route) => true);
            }
            break;
          case 4:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => OficialDutyReport(
                            odEmpList: widget.odEmpList,
                          )),
                  (route) => true);
            }
            break;

          case 5 :{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => TravelReportScreen()),
                    (route) => true);
          }
            break;

          case 6:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SalarySlip()),
                  (route) => true);
            }
            break;
          case 7:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PersonalInfo(
                            personalInfo: widget.personalInfo,
                          )),
                  (route) => true);
            }
            break;
          case 8:
            {
              Utility().clearSharedPreference();
              Utility().deleteDatabase(databaseName);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>  LoginPage()),
                  (route) => false);
            }
            break;
          default:
            {
              Navigator.pop(context);
            }
            break;
        }
      },
    );
  }

  void _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = version + packageInfo.version;
    });

  }
}
