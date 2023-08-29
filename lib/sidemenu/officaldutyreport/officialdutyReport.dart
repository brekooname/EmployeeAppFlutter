import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/home_page.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

import '../../theme/string.dart';

class OficialDutyReport extends StatefulWidget {
  List<Odemp> odEmpList = [];

  OficialDutyReport({Key? key, required this.odEmpList}) : super(key: key);

  @override
  State<OficialDutyReport> createState() => _OficialDutyReportState();
}

class _OficialDutyReportState extends State<OficialDutyReport> {

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
        title:   robotoTextWidget(
            textval: officialDuty,
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  const BoxDecoration(
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
                              label: Center( child: setTitle("OD No")),
                              numeric: false,),
                            DataColumn(
                                label: Center(child: setTitle("Start Date")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("End Date")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Duration")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Status")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("OD/OT Status")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Visit Place")),
                                numeric: true),
                            DataColumn(
                                label: Center(child: setTitle("Purpose")),
                                numeric: true),
                          ],
                          rows: widget.odEmpList
                              .map((odEmpList) => DataRow(
                            cells: [
                              DataCell(
                                  setValue(odEmpList.odno ?? "")),
                              DataCell(setValue(
                                  odEmpList.odstdateC ?? "")),
                              DataCell(setValue(
                                  odEmpList.odedateC ?? "")),
                              DataCell(setValue(
                                  odEmpList.horo ?? "")),
                              DataCell(setValue(
                                  odEmpList.odaprdtC ?? "")),
                              DataCell(setValue(
                                  odEmpList.atnStatus ?? "")),
                              DataCell(setValue(
                                  odEmpList.vplace ?? "")),
                              DataCell(setValue(
                                  odEmpList.purpose1 ?? "")),
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
