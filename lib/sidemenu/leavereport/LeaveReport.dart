import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

class LeaveReport extends StatefulWidget {
  List<Leaveemp> leaveEmpList = [];

  LeaveReport({Key? key, required this.leaveEmpList}) : super(key: key);

  @override
  State<LeaveReport> createState() => _LeaveReportState();
}

class _LeaveReportState extends State<LeaveReport> {

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

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: "Leave Table",
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );}
        ),
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/shaktiLogo.png'),
            fit: BoxFit.contain,
            opacity: 0.3,
          ),
        ),
        child:  _buildTable(context),
      ),
    );
  }

  _buildTable(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height/1.13,
      child:  Scrollbar(
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
                              label: Center( child: setTitle("Leave No")),
                              numeric: false,),
                            DataColumn(
                                label: Center(child: setTitle("Duration")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Leave From")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Leave To")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Type")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Reason")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Approved")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Deleted")),
                                numeric: true),
                          ],
                          rows: widget.leaveEmpList
                              .map((leaveEmpList) => DataRow(
                            cells: [
                              DataCell(
                                  setValue(leaveEmpList.leavNo ?? "")),
                              DataCell(setValue(
                                  leaveEmpList.horo ?? "")),
                              DataCell(setValue(
                                  leaveEmpList.levFrm ?? "")),
                              DataCell(setValue(
                                  leaveEmpList.levTo ?? "")),
                              DataCell(setValue(
                                  leaveEmpList.levTyp ?? "")),

                              DataCell(setValue(
                                  leaveEmpList.reason ?? "")),
                              DataCell(setValue(
                                  leaveEmpList.apphod ?? "")),
                              DataCell(setValue(
                                  leaveEmpList.dele ?? "")),
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
