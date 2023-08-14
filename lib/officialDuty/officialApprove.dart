// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/home_page.dart';

import 'package:shakti_employee_app/officialDuty/indirect/indirect.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

import '../home/model/ScyncAndroidtoSAP.dart';

class OfficialApproved extends StatefulWidget {

  List<Pendingod> pendindOdList = [];
   OfficialApproved({Key? key ,required this.pendindOdList}) : super(key: key);

  @override
  State<OfficialApproved> createState() => _OfficialApprovedState();
}

class _OfficialApprovedState extends State<OfficialApproved> {

  List<Pendingod> directODList = [];
  List<Pendingod> inDirectODList = [];

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
            title: const robotoTextWidget(textval: "Official Duty Approve", colorval: AppColor.whiteColor,
                sizeval: 18, fontWeight: FontWeight.normal),
            bottom:  const TabBar(
              isScrollable: false,
              indicatorColor: AppColor.whiteColor,
              indicatorPadding: EdgeInsets.all(5),
              tabs: [
                Tab(child: robotoTextWidget(textval: 'Direct',
                    colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
                Tab(child: robotoTextWidget(textval: 'InDirect', colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
              ],
            )
        ),
        body:  TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // first tab bar view widget
            InDirect( Status: 'D', pendindOdList: directODList,),
            InDirect( Status: 'I', pendindOdList: inDirectODList,),
          ],
        ),
      ),
    );
  }

  void setArrary() {
    setState(() {
      for(var i =0 ; i < widget.pendindOdList.length ; i++ ){
        if(widget.pendindOdList[i].directIndirect == 'X'){
          directODList.add(Pendingod(odno: widget.pendindOdList[i].odno, horo:  widget.pendindOdList[i].horo, ename: widget.pendindOdList[i].ename, odstdateC: widget.pendindOdList[i].odstdateC, odedateC: widget.pendindOdList[i].odedateC, atnStatus:widget.pendindOdList[i].atnStatus, vplace: widget.pendindOdList[i].vplace, purpose1: widget.pendindOdList[i].purpose1, purpose2: widget.pendindOdList[i].purpose2, purpose3: widget.pendindOdList[i].purpose3, remark: widget.pendindOdList[i].remark, directIndirect: widget.pendindOdList[i].directIndirect));
        }else{
          inDirectODList.add(Pendingod(odno: widget.pendindOdList[i].odno, horo:  widget.pendindOdList[i].horo, ename: widget.pendindOdList[i].ename, odstdateC: widget.pendindOdList[i].odstdateC, odedateC: widget.pendindOdList[i].odedateC, atnStatus:widget.pendindOdList[i].atnStatus, vplace: widget.pendindOdList[i].vplace, purpose1: widget.pendindOdList[i].purpose1, purpose2: widget.pendindOdList[i].purpose2, purpose3: widget.pendindOdList[i].purpose3, remark: widget.pendindOdList[i].remark, directIndirect: widget.pendindOdList[i].directIndirect));
        }
      }
    });
  }


}
