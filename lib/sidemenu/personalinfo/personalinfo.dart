// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

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
        title:   robotoTextWidget(
            textval: personalInfo,
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
      body: widget.personalInfo.isNotEmpty?Column(
        children: [
          detailWidget(sapcode, nameValue!),
          detailWidget(nametxt, widget.personalInfo[0].pernr),
          detailWidget(department, widget.personalInfo[0].btrtlTxt),
          detailWidget(designation,  widget.personalInfo[0].perskTxt),
          detailWidget(reportingManger,  widget.personalInfo[0].hodEname),
          detailWidget(mobile,  widget.personalInfo[0].telnr),
          detailWidget(emailtxt,  widget.personalInfo[0].emailShkt),
          detailWidget(addresstxt,  widget.personalInfo[0].address),
          detailWidget(dobtxt,  widget.personalInfo[0].birth),
        ],
      ):Container(),
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
