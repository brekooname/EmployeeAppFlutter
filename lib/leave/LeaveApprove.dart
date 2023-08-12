// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/home_page.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/leave/indirectLeave.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';


class LeaveApproved extends StatefulWidget {
  List<Pendingleave> pendingLeaveList = [];

   LeaveApproved({Key? key , required this.pendingLeaveList}) : super(key: key);


  @override
  State<LeaveApproved> createState() => _LeaveApprovedState();
}

class _LeaveApprovedState extends State<LeaveApproved> {

  List<Pendingleave> directList = [];
  List<Pendingleave> inDirectList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setArrary();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:  AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColor.themeColor,
            title: robotoTextWidget(textval: "Leave Approve", colorval: AppColor.whiteColor,
                sizeval: 18, fontWeight: FontWeight.normal),
            bottom:  TabBar(
              isScrollable: false,
              indicatorColor: AppColor.whiteColor,
              indicatorPadding: const EdgeInsets.all(5),
              tabs: [
                Tab(child: robotoTextWidget(textval: 'Direct',
                    colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
                Tab(child: robotoTextWidget(textval: 'InDirect', colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
              ],
            )
        ),
        body:  TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            // first tab bar view widget
            InDirectLeave( Status: 'D', pendindLeaveList: directList,),
            InDirectLeave( Status: 'I', pendindLeaveList: inDirectList,),
          ],
        ),
      ),
    );
  }

  void setArrary() {
    setState(() {

      for(var i =0 ; i < widget.pendingLeaveList.length ; i++ ){
        if(widget.pendingLeaveList[i].directIndirect == 'X'){
          directList.add(Pendingleave(leavNo: widget.pendingLeaveList[i].leavNo, horo: widget.pendingLeaveList[i].horo, pernr: widget.pendingLeaveList[i].pernr, name: widget.pendingLeaveList[i].name, dedQuta1: widget.pendingLeaveList[i].dedQuta1, levFrm: widget.pendingLeaveList[i].levFrm, levFr: widget.pendingLeaveList[i].levFr, levTo: widget.pendingLeaveList[i].levTo, levT: widget.pendingLeaveList[i].levT, timFrm: widget.pendingLeaveList[i].timFrm, timTo: widget.pendingLeaveList[i].timTo, reason: widget.pendingLeaveList[i].reason, adminChrg1: widget.pendingLeaveList[i].adminChrg1, nameperl: widget.pendingLeaveList[i].nameperl, adminChrg2: widget.pendingLeaveList[i].adminChrg2, nameperl2: widget.pendingLeaveList[i].nameperl2, nameperl3: widget.pendingLeaveList[i].nameperl3, nameperl4: widget.pendingLeaveList[i].nameperl4, person: widget.pendingLeaveList[i].person, directIndirect: widget.pendingLeaveList[i].directIndirect));
        }else{
          inDirectList.add(Pendingleave(leavNo: widget.pendingLeaveList[i].leavNo, horo: widget.pendingLeaveList[i].horo, pernr: widget.pendingLeaveList[i].pernr, name: widget.pendingLeaveList[i].name, dedQuta1: widget.pendingLeaveList[i].dedQuta1, levFrm: widget.pendingLeaveList[i].levFrm, levFr: widget.pendingLeaveList[i].levFr, levTo: widget.pendingLeaveList[i].levTo, levT: widget.pendingLeaveList[i].levT, timFrm: widget.pendingLeaveList[i].timFrm, timTo: widget.pendingLeaveList[i].timTo, reason: widget.pendingLeaveList[i].reason, adminChrg1: widget.pendingLeaveList[i].adminChrg1, nameperl: widget.pendingLeaveList[i].nameperl, adminChrg2: widget.pendingLeaveList[i].adminChrg2, nameperl2: widget.pendingLeaveList[i].nameperl2, nameperl3: widget.pendingLeaveList[i].nameperl3, nameperl4: widget.pendingLeaveList[i].nameperl4, person: widget.pendingLeaveList[i].person, directIndirect: widget.pendingLeaveList[i].directIndirect));

        }

        print("odList====>${widget.pendingLeaveList.length}");

        print("odList2 D====>${directList.length}");

        print("odList3 ID====>${inDirectList.length}");
      }

    });
  }
}
