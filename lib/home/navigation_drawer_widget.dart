import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

import '../main.dart';
import '../sidemenu/attendance/attendanceReport.dart';
import '../sidemenu/leavereport/LeaveReport.dart';
import '../sidemenu/officaldutyreport/officialdutyReport.dart';
import '../sidemenu/personalinfo/personalinfo.dart';
import '../sidemenu/salaryslip/salaryslip.dart';
import '../theme/color.dart';
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
                child: robotoTextWidget(
                    textval: widget.name[0],
                    colorval: AppColor.themeColor,
                    sizeval: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
            navigationItemWidget(0, Icons.home, "Home"),
            navigationItemWidget(1, Icons.calendar_month, "Attendance"),
            navigationItemWidget(2, Icons.calendar_today_rounded, "Leave"),
            navigationItemWidget(3, Icons.person_outline_rounded, "Official Duty"),
            navigationItemWidget(4, Icons.person_outline_rounded, "Payslip"),
            navigationItemWidget(5, Icons.person, "Personal Info"),
            navigationItemWidget(6, Icons.logout, "Logout"),
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
                      builder: (context) => AttendanceReport(
                            attendenceList: widget.attendenceList,
                          )),
                  (route) => true);
            }
            break;
          case 2:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => LeaveReport(
                            leaveEmpList: widget.leaveEmpList,
                          )),
                  (route) => true);
            }
            break;
          case 3:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => OficialDutyReport(
                            odEmpList: widget.odEmpList,
                          )),
                  (route) => true);
            }
            break;
          case 4:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SalarySlip()),
                  (route) => true);
            }
            break;
          case 5:
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PersonalInfo(
                            personalInfo: widget.personalInfo,
                          )),
                  (route) => true);
            }
            break;
          case 6:
            {
              Utility().clearSharedPreference();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
      appVersion = 'Version :- ${packageInfo.version}';
    });

  }
}
