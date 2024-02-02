import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/string.dart';
import '../../webservice/constant.dart';

class SalarySlip extends StatefulWidget {
  const SalarySlip({Key? key}) : super(key: key);

  @override
  State<SalarySlip> createState() => _SalarySlipState();
}

class _SalarySlipState extends State<SalarySlip> {

  String? yearSpinner , monthSpinner ;
  bool isLoading = false;
  var yearList = [
    '2023',
    '2024',
  ];

  var monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  String? currentMonth, currentDate;
  String dateFormat = "MM";
  int? selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    currentMonth = DateFormat(dateFormat).format(DateTime.now());
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print('${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

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
              hintText: selectYear,
              fillColor: Colors.white),
          value: yearSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectYear : "",
          items: yearList.map((year) => DropdownMenuItem(
              value: year ,
              child: robotoTextWidget(
                  textval: year ,
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
              hintText: selectMonth,
              fillColor: Colors.white),
          value: monthSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectMonth : "",
          items: monthList.map((month) => DropdownMenuItem(
              value: month ,
              child: robotoTextWidget(
                  textval: month ,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            monthSpinner = value.toString();
            for (var i = 0; i < monthList.length; i++) {
              if (monthSpinner == monthList[i]) {
                selectedIndex = i + 1;
              }
            }
            print('selectedIndex=====>$selectedIndex');
            setState(() {});
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


    String sapCode =  sharedPreferences.getString(userID).toString() ;
    if (yearSpinner == null || yearSpinner!.isEmpty) {
      Utility().showToast(pselectYear);
    } else if (monthSpinner == null || monthSpinner!.isEmpty) {
      Utility().showToast(pselectMonth);
    } else {
      DateTime dt1 = DateTime.parse("$currentDate");
      String compareDate = '$yearSpinner-$monthSpinner-05';

      DateTime dt2 = DateTime.parse(Utility.convertDateFormat(
          compareDate, "yyyy-MMM-dd", "yyyy-MM-dd hh:mm:ss"));
      if (dt1.compareTo(dt2) == 0 || dt1.compareTo(dt2) > 0) {
        print("Both date time are at same moment.");
        print("DT1 is after DT2");
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
            _launchUrl(
                '$salarySlipUrl?id=$sapCode&yr=$yearSpinner&mo=$monthSpinner');
          } else {
            Utility().showInSnackBar(
                value: checkInternetConnection, context: context);
          }
        });
      } else {
        Utility().showInSnackBar(
            value: 'Can not download this month of payslip', context: context);
      }
    }
  }


  Future<void> _launchUrl(String _url) async {
    setState(() {
      isLoading = true;
    });

    print("url====>${Uri.parse(_url)}");
    if (!await launchUrl(Uri.parse(_url) ,mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $_url');
    }

    setState(() {
      isLoading = false;
    });
  }
}
