import 'package:flutter/material.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/string.dart';
import '../../webservice/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class SalarySlip extends StatefulWidget {
  const SalarySlip({Key? key}) : super(key: key);

  @override
  State<SalarySlip> createState() => _SalarySlipState();
}

class _SalarySlipState extends State<SalarySlip> {

  String? yearSpinner , monthSpinner ;
  bool isLoading = false;
  var yearList = [
    'Select Year',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
  ];

  var monthList = [
    "Select Month", "Jan", "Feb", "Mar", "Apr",
    "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title:   robotoTextWidget(
            textval: downloadSalary,
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          child:  Column(
            children: [
              SizedBox(
                height: 10,
              ),
              yearSpinnerWidget(),
              SizedBox(
                height: 10,
              ),
              monthSpinnerWidget(),
              downloadWidget(),
            ],
          ),
        ),
      ),
    );
  }

  yearSpinnerWidget() {
    return SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.themeColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
              hintText: selectLeaveType,
              fillColor: Colors.white),
          value: yearSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectLeaveType : "",
          items: yearList.map((leaveType) => DropdownMenuItem(
              value: leaveType ,
              child: robotoTextWidget(
                  textval: leaveType ,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            setState(() {
              yearSpinner = value.toString();
            });
          },
        ));
  }

  monthSpinnerWidget() {
    return SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.themeColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
              hintText: selectLeaveType,
              fillColor: Colors.white),
          value: monthSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectLeaveType : "",
          items: monthList.map((leaveType) => DropdownMenuItem(
              value: leaveType ,
              child: robotoTextWidget(
                  textval: leaveType ,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            setState(() {
              monthSpinner = value.toString();
            });
          },
        ));
  }

  downloadWidget()  {
    return  GestureDetector(
        onTap: () {
          Validation();
        },
        child: Container(
          height: 50,
         margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: isLoading
                ? const SizedBox(
              height: 30,
              width: 30,
              child:
              CircularProgressIndicator(
                color: AppColor.whiteColor,
              ),
            )
                :   robotoTextWidget(
                textval: downloadSalary,
                colorval: Colors.white,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Future<void> Validation() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    yearSpinner ??= "";
    monthSpinner ??= "";

    String sapCode =  sharedPreferences.getString(userID).toString() ;
    if(yearSpinner!.isEmpty){
      Utility().showToast(pselectYear);
    } else if(monthSpinner!.isEmpty){
      Utility().showToast(pselectMonth);
    }else{
      _launchUrl('$salarySlipUrl?id=$sapCode&yr=$yearSpinner&mo=$monthSpinner');

    }

  }


  Future<void> _launchUrl(String _url) async {
    setState(() {
      isLoading = true;
    });

    if (!await launchUrl(Uri.parse(_url) ,mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $_url');
    }

    setState(() {
      isLoading = false;
    });
  }

}
