import 'package:flutter/material.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/home_page.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../theme/string.dart';
import '../../webservice/constant.dart';

class SalarySlip extends StatefulWidget {
  const SalarySlip({Key? key}) : super(key: key);

  @override
  State<SalarySlip> createState() => _SalarySlipState();
}

class _SalarySlipState extends State<SalarySlip> {

  String? yearSpinner= "Select Year", monthSpinner = "Select Month";
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
        title: const robotoTextWidget(
            textval: ""
                "Download Salary Slip ",
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

        child: SingleChildScrollView(
          child: Column(
            children: [

              yearSpinnerWidget(),
              monthSpinnerWidget(),
              downloadWidget(),
            ],
          ),
        ),
      ),
    );
  }

  yearSpinnerWidget() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(height: 0,),
          value: yearSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: yearList.map((String year) {
            return DropdownMenuItem(
              value: year,
              child: Center(child: robotoTextWidget(textval: year, colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              yearSpinner = newValue!;
            });
          },
        ),
      ),);
  }

  monthSpinnerWidget() {
    return  Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(height: 0,),
          value: monthSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: monthList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              monthSpinner = newValue!;
            });
          },
        ),
      ),
    );
  }

  downloadWidget()  {
    return  GestureDetector(
        onTap: () {
          Validation();
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(
              horizontal: 50),
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
                : const robotoTextWidget(
                textval: "Download Salary Slip",
                colorval: Colors.white,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Future<void> Validation() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String sapCode =  sharedPreferences.getString(userID).toString() ;
    if(yearSpinner == "Select Year"){
      Utility().showToast("Please select year");
    } else if(monthSpinner == "Select Month"){
      Utility().showToast("Please select Month");
    }else{
      _launchUrl('$salarySlipUrl?id=$sapCode&yr=$yearSpinner&mo=$monthSpinner');

    }

  }


  Future<void> _launchUrl(String _url) async {
    setState(() {
      isLoading = true;
    });
  }
}
