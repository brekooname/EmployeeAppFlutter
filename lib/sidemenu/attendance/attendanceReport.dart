// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

class AttendanceReport extends StatefulWidget {
  List<Attendanceemp> attendenceList = [];

  AttendanceReport({Key? key, required this.attendenceList}) : super(key: key);

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: const robotoTextWidget(
            textval: "Attendance Table",
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/shaktiLogo.png'),
            fit: BoxFit.contain,
            opacity: 0.3,
          ),
        ),
        child: _buildTable(context),
      ),
    );
  }

  _buildTable(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.13,
      child: Scrollbar(
          controller: _vertical,
          thumbVisibility: true,
          trackVisibility: true,
          child: Scrollbar(
              controller: _horizontal,
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notif) => notif.depth == 1,
              child: SingleChildScrollView(
                  controller: _vertical,
                  child: SingleChildScrollView(
                      controller: _horizontal,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: <DataColumn>[
                            DataColumn(
                              label: Center(child: setTitle("Date")),
                              numeric: false,
                            ),
                            DataColumn(
                                label: Center(child: setTitle("In Time")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Out Time")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Working hrs")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Status")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Leave Type")),
                                numeric: true),
                          ],
                          rows: widget.attendenceList
                              .map(
                                (attendenceList) => DataRow(
                                  cells: [
                                    DataCell(
                                        setValue(attendenceList.begdat ?? "")),
                                    DataCell(
                                        setValue(attendenceList.indz ?? "")),
                                    DataCell(
                                        setValue(attendenceList.iodz ?? "")),
                                    DataCell(
                                        setValue(attendenceList.totdz ?? "")),
                                    DataCell(setValue(
                                        attendenceList.atnStatus ?? "")),
                                    DataCell(setValue(
                                        attendenceList.leaveTyp ?? "")),
                                  ],
                                ),
                              )
                              .toList()))))),
    );
  }

  Widget setTitle(String value) {
    return robotoTextWidget(
        textval: value,
        colorval: AppColor.themeColor,
        sizeval: 14,
        fontWeight: FontWeight.bold);
  }

  Widget setValue(String value) {
    return robotoTextWidget(
        textval: value,
        colorval: Colors.black45,
        sizeval: 12,
        fontWeight: FontWeight.w600);
  }
}
