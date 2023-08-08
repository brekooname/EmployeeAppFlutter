import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'dart:convert' as convert;
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import '../uiwidget/robotoTextWidget.dart';
import 'model/vendornamelistresponse.dart' as VenderList;
import 'model/vendornamelistresponse.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  String? _selectedType;

  String TypeSpinner = 'Select Visit At ';

  var TypeList = [
    'Select Visit At ',
    'Supplier Premises',
    'Shakti H.O',
  ];

  String statusType = "Select Status";

  var statusList = [
    'Select Status',
    'Open',
    'Close',
    'In Progress',
  ];

  List<VenderList.Response> vendorNameList = [];
  TextEditingController vendoreName = TextEditingController();
  TextEditingController vendoreCode = TextEditingController();
  TextEditingController vendoreAddress = TextEditingController();
  TextEditingController vendoreContac = TextEditingController();
  TextEditingController person1 = TextEditingController();
  TextEditingController person2 = TextEditingController();
  TextEditingController person3 = TextEditingController();

  TextEditingController agenda = TextEditingController();
  TextEditingController discussion = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime datefrom = DateTime.now();
  String? indianFromDate, selectedLeaveType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indianFromDate =  DateFormat("dd/MM/yyyy").format(DateTime.now());
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
            textval: "Daily Report",
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            radtiobuttonWidget(),
            textVendorFeildWidget(
              "Vendor Name",
            ),
            textFeildWidget("Vendor Code", vendoreCode),
            textFeildWidget("Vendor Address", vendoreAddress),
            textFeildWidget("Vendor Contact N0", vendoreContac),
            dateTextFeildWidget("Current Date",
                DateFormat("dd-MM-yyyy").format(DateTime.now())),
            TypeSpinnerWidget(),
            textFeildWidget("Responsible person", person1),
            textFeildWidget("Responsible person 2", person2),
            textFeildWidget("Responsible person 3", person3),
            longTextFeildWidget("Agenda", agenda),
            longTextFeildWidget("Discussion", discussion),
            statusSpinnerWidget(),
            datePickerWidget("Target Date", indianFromDate.toString()),
          ],
        ),
      ),
    );
  }

  textFeildWidget(String hinttxt, TextEditingController visitPlace) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hinttxt,
              style:
                  const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: const EdgeInsets.only(left: 15),
          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: visitPlace,
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Please Enter " + hinttxt,
              hintStyle: const TextStyle(color: AppColor.themeColor),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  radtiobuttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Row(
              children: <Widget>[
                Radio(
                  value: "Vendor",
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Text(
                  'Vendor',
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Row(
              children: <Widget>[
                Radio(
                  value: "Prospective Vendor",
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Flexible(
                    child: Text(
                  'Prospective Vendor',
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TypeSpinnerWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(
            height: 0,
          ),
          value: TypeSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: TypeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(
                  child: robotoTextWidget(
                      textval: items,
                      colorval: AppColor.themeColor,
                      sizeval: 18,
                      fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              TypeSpinner = newValue!;
            });
          },
        ),
      ),
    );
  }

  dateTextFeildWidget(String s, String date) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            s,
            style:
                const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
          )),
      Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.themeColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: TextField(
          style: const TextStyle(color: AppColor.themeColor),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: date,
            hintStyle: const TextStyle(color: AppColor.themeColor),
          ),
          keyboardType: TextInputType.text,
        ),
      )
    ]);
  }

  longTextFeildWidget(String s, TextEditingController longtext) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              s,
              style:
                  const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: const EdgeInsets.only(left: 15),
          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            maxLines: 3,
            controller: longtext,
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Please Enter " + s,
              hintStyle: const TextStyle(color: AppColor.themeColor),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  statusSpinnerWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(
            height: 0,
          ),
          value: statusType,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: statusList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(
                  child: robotoTextWidget(
                      textval: items,
                      colorval: AppColor.themeColor,
                      sizeval: 18,
                      fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              statusType = newValue!;
            });
          },
        ),
      ),
    );
  }

  datePickerWidget(String text, String date) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 20,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.whiteColor,
              ),
              onPressed: () => _selectDate(context, text),
              child: robotoTextWidget(
                  textval: text,
                  colorval: AppColor.themeColor,
                  sizeval: 15,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 15.0,
            ),
            robotoTextWidget(
                textval: date.toString(),
                colorval: AppColor.themeColor,
                sizeval: 20,
                fontWeight: FontWeight.normal)
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String text) async {
    print("indianDate===> $text}");
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              splashColor: Colors.black,
              textTheme: const TextTheme(
                titleSmall: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
              ),
              dialogBackgroundColor: Colors.white,
              colorScheme: const ColorScheme.light(
                      primary: Color(0xff1565C0),
                      primaryContainer: Colors.black,
                      secondaryContainer: Colors.black,
                      onSecondary: Colors.black,
                      onPrimary: Colors.white,
                      surface: Colors.black,
                      onSurface: Colors.black,
                      secondary: Colors.black)
                  .copyWith(
                      primaryContainer: Colors.grey, secondary: Colors.black),
            ),
            child: child ?? const Text(""),
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate) {
      setState(() {
        if (text == "Target Date") {
          datefrom = picked;
          indianFromDate = DateFormat("dd/MM/yyyy").format(picked);
          // print("text===>${text}");
        }

        print("indianDate1===> ${datefrom}");
      });
    }
  }

  Future<void> vendorNameListAPI(String value) async {
    var jsonData = null;
    dynamic response = await HTTP.get(vendorNameAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      VendorNameResponse vendorNameResponse =
          VendorNameResponse.fromJson(jsonData);
      if (vendorNameResponse.status == "true" &&
          vendorNameResponse.response.isNotEmpty)
        setState(() {
          vendorNameList = vendorNameResponse.response;
          print('vendoreNAmeList=====>${vendorNameList.length}');
        });
    }
  }

  textVendorFeildWidget(String hinttxt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
             hinttxt,
              style:
                  const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10,right: 10),
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SearchField<List<VenderList.Response>>(
            suggestions: vendorNameList
                .map(
                  (vendornamelist) =>
                      SearchFieldListItem<List<VenderList.Response>>(
                    vendornamelist.name1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        vendornamelist.name1,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: AppColor.themeColor),
                      ),
                    ),
                  ),
                )
                .toList(),
            searchInputDecoration: InputDecoration(
              hintText:  "Search by "+hinttxt,
              hintStyle: const TextStyle(
                  color: AppColor.themeColor, ),
              border: InputBorder.none,
            ),
            onSearchTextChanged: (serachValue) {
              if (serachValue.length > 2) {
                vendorNameListAPI(serachValue);
              }
              return null;
            },
            onSubmit: (String value) {
              setState(() {
                vendoreContac.text =  vendorNameList[0].telf1;

                print("submitted\n ${value}");
              });
            },
          ),
        )
      ],
    );
  }


}
