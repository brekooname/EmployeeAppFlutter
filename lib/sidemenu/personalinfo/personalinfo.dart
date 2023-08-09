// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Util/utility.dart';
import '../../home/model/personalindoresponse.dart';
import '../../theme/string.dart';

class PersonalInfo extends StatefulWidget {

  List<Emp> personalInfo = [ ];
  PersonalInfo({Key? key, required this.personalInfo}) : super(key: key);

  @override
  State<PersonalInfo> createState() => PersonalInfoState();
}

class PersonalInfoState extends State<PersonalInfo> {

  String? nameValue = "null";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameValue();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: const robotoTextWidget(
            textval: ""
                "Personal Info",
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );}
        ),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Container(
        child: Column(
          children: [

            detailWidget("SapCode", nameValue!),
            detailWidget("Name", widget.personalInfo[0].pernr),
            detailWidget("Department", widget.personalInfo[0].btrtlTxt),
            detailWidget("Designation",  widget.personalInfo[0].perskTxt),
            detailWidget("Reporting Manger",  widget.personalInfo[0].hodEname),
            detailWidget("Mobile",  widget.personalInfo[0].telnr),
            detailWidget("E-mail",  widget.personalInfo[0].emailShkt),
            detailWidget("Address",  widget.personalInfo[0].address),
            detailWidget("DOB",  widget.personalInfo[0].birth),

          ],
        ),
      ),
    );
  }

  detailWidget(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 3, ),
      height: 52,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding( padding : const EdgeInsets.only(left: 10),
               child: robotoTextWidget(textval: title, colorval: Colors.black45,
                   sizeval: 15, fontWeight: FontWeight.bold)),
         const SizedBox(width: 10,),
         Flexible(child: robotoTextWidget(textval: value, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400))
    ],
        ),
      ),
    );
  }

  Future<void> getNameValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      nameValue = sharedPreferences.getString(name) .toString()  ;
    });
  }

}
