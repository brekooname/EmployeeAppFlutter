// ignore_for_file: library_prefixes, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/leave/model/leaveRequestModel.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../webservice/APIDirectory.dart';

// ignore: must_be_immutable
class LeaveRequestScreen extends StatefulWidget {
  LeaveRequestScreen(
      {Key? key, required this.LeaveBalanceList, required this.activeEmpList})
      : super(key: key);
  List<Leavebalance> LeaveBalanceList = [];
  List<Activeemployee> activeEmpList = [];

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  bool isLoading = false;
  TextEditingController reason = TextEditingController();
  String perInCharge1 = "",
      perInCharge2 = "",
      perInCharge3 = "",
      perInCharge4 = "";

  String leaveTypeSpinner = 'Select Leave Type';
  DateTime selectedDate = DateTime.now();
  DateTime datefrom = DateTime.now(), dateto = DateTime.now();
  String? indianFromDate, indianToDate, selectedLeaveType, dayTypeSpinner;
  bool isListVisible = false;

  // List of items in our dropdown menu
  var dayTypeList = [
    'Full Day or More',
    'Half Day',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indianFromDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
    indianToDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: leaveRequest,
            colorval: AppColor.whiteColor,
            sizeval: 16,
            fontWeight: FontWeight.w600),
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
      body: Container(
        margin: const EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              leaveTypeSpinnerWidget(),
              const SizedBox(
                height: 10,
              ),
              dayTypeSpinnerWidget(),
              const SizedBox(
                height: 10,
              ),
              datePickerWidget("Leave From", indianFromDate.toString()),
              const SizedBox(
                height: 10,
              ),
              datePickerWidget("Leave To", indianToDate.toString()),
              reasonForLeave(),
              assginToSpinnerWidget(context, widget.activeEmpList, "0"),
              assginToSpinnerWidget(context, widget.activeEmpList, "1"),
              assginToSpinnerWidget(context, widget.activeEmpList, "2"),
              assginToSpinnerWidget(context, widget.activeEmpList, "3"),
              const SizedBox(
                height: 10,
              ),
              submitWidget(),
            ],
          ),
        ),
      ),
    );
  }

  submitWidget() {
    return GestureDetector(
        onTap: () {
          Validation();
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: AppColor.whiteColor,
                    ),
                  )
                : robotoTextWidget(
                    textval: submit,
                    colorval: Colors.white,
                    sizeval: 14,
                    fontWeight: FontWeight.bold),
          ),
        ));
  }

  leaveTypeSpinnerWidget() {
    return Container(
        height: 60,
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
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
              hintText: 'Select leave type',
              fillColor: Colors.white),
          value: selectedLeaveType,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please Select leave type' : "",
          items: widget.LeaveBalanceList.map((leaveType) => DropdownMenuItem(
              value: leaveType.leaveType,
              child: robotoTextWidget(
                  textval: leaveType.leaveType,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedLeaveType = value.toString();
            });
          },
        ));
  }

  Widget assginToSpinnerWidget(BuildContext context,
      List<Activeemployee> activeemployee, String perInCharge) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SearchField<List<Activeemployee>>(
        suggestions: isListVisible
            ? activeemployee
                .map(
                  (activeemployee) => SearchFieldListItem<List<Activeemployee>>(
                    activeemployee.ename,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: robotoTextWidget(
                          textval: activeemployee.ename,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                .toList()
            : [],
        searchStyle: const TextStyle(
            fontSize: 14,
            color: AppColor.themeColor,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600),
        searchInputDecoration: const InputDecoration(
          hintText: "Assign Charge To",
          hintStyle: TextStyle(
              color: AppColor.themeColor, fontWeight: FontWeight.normal),
          prefixIcon: Icon(
            Icons.person,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
        ),
        onSearchTextChanged: (String value) {
          setState(() {
            if (value.length > 2) {
              isListVisible = true;
              if (perInCharge == "0") {
                perInCharge1 = value;
              } else if (perInCharge == "1") {
                perInCharge2 = value;
              } else if (perInCharge == "2") {
                perInCharge3 = value;
              } else if (perInCharge == "3") {
                perInCharge4 = value;
              }
            } else {
              isListVisible = false;
            }
          });
        },
      ),
    );
  }

  dayTypeSpinnerWidget() {
    return Container(
        height: 60,
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
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
              hintText: 'Select Day or More',
              fillColor: Colors.white),
          value: dayTypeSpinner,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please Select Day or More' : "",
          items: dayTypeList
              .map((dayType) => DropdownMenuItem(
                  value: dayType,
                  child: robotoTextWidget(
                      textval: dayType,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              dayTypeSpinner = value.toString();
            });
          },
        ));
  }

  reasonForLeave() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: reason,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.edit_note,
            color: AppColor.themeColor,
          ),
          border: InputBorder.none,
          hintText: "Reason",
          hintStyle: TextStyle(color: AppColor.themeColor),
        ),
        keyboardType: TextInputType.text,
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
        if (text == "Leave From") {
          datefrom = picked;
          indianFromDate = DateFormat("dd/MM/yyyy").format(picked);
        } else if (text == "Leave To") {
          dateto = picked;
          indianToDate = DateFormat("dd/MM/yyyy").format(picked);
        }
      });
    }
  }

  void Validation() {
    selectedLeaveType ??= "";
    if (selectedLeaveType!.isEmpty) {
      Utility().showToast("Please Select Leave Type");
    } else if (dateto.compareTo(datefrom) < 0) {
      Utility().showToast("To date can not be smaller then From date");
    } else if (reason.text.toString().isEmpty) {
      Utility().showToast("Please enter reason");
    } else if (perInCharge1.isEmpty) {
      Utility().showToast("Please enter person in charge1");
    } else if (perInCharge2.isEmpty) {
      Utility().showToast("Please enter person in charge2");
    } else {
      applyLeave();
    }
  }

  Future<void> applyLeave() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? sapcode = sharedPreferences.getString(sapCodetxt);

    dynamic response = await HTTP.get(createLeaveAPI(
        sapcode!,
        selectedLeaveType.toString(),
        dayTypeSpinner!,
        indianFromDate!,
        indianToDate!,
        reason.text.toString(),
        perInCharge1.toString(),
        perInCharge2.toString(),
        perInCharge3.toString(),
        perInCharge4.toString()));
    if (response != null && response.statusCode == 200) {
      print("response======>${response.toString()}");
      Iterable l = json.decode(response.body);
      List<LeaveRequestModelResponse> leave =
          List<LeaveRequestModelResponse>.from(
              l.map((model) => LeaveRequestModelResponse.fromJson(model)));
      print("response======>${leave[0].name}");

      if (leave[0].name.compareTo("Leave request created") == 0) {
        Utility().showToast(leave[0].name);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => true);
      } else {
        Utility().showToast(leave[0].name);
      }
    }
  }
}
