// ignore_for_file: library_prefixes, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/home_page.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/leave/model/leaveRequestModel.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../webservice/APIDirectory.dart';
import '../webservice/constant.dart';

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
      perInCharge4 = "",
      dateTimeFormat ="dd/MM/yyyy";

  String leaveTypeSpinner = 'Select Leave Type';
  String?  selectedLeaveType, dayTypeSpinner,selectedFromDate, selectedToDate;
  bool isListVisible = false;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTime? pickedDate;


  var dayTypeList = [
    'Full Day or More',
    'Half Day',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedFromDate = DateFormat(dateTimeFormat).format(DateTime.now());
      selectedToDate = DateFormat(dateTimeFormat).format(DateTime.now());
      fromDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());
      toDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());

    });
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
              Navigator.of(context).pop();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  datePickerWidget(
                      selectedFromDate!, fromDateController, "0"),
                  datePickerWidget(
                      selectedToDate!, toDateController, "1")
                ],
              ),
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



  leaveTypeSpinnerWidget() {
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
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedLeaveType = value.toString();
            });
          },
        ));
  }

  dayTypeSpinnerWidget() {
    return Container(
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
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              dayTypeSpinner = value.toString();
            });
          },
        ));
  }

  datePickerWidget(
      String fromTO, TextEditingController DateController, String value) {
    return GestureDetector(
      onTap: () {
        _selectDate(context, value);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 2.2,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.themeColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month,
              color: AppColor.themeColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                child: TextField(
                  controller: DateController,
                  maxLines: 1,
                  showCursor: false,
                  enabled: false,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: fromTO,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                  style: const TextStyle(fontSize: 12, fontFamily: 'Roboto',fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String value) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: value == "0"
            ? DateTime.now()
            : selectedFromDate != DateFormat(dateTimeFormat).format(DateTime.now())
            ? DateTime(2023)
            : DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate:  DateTime(2050));
    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat(dateTimeFormat).format(pickedDate!);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        if (value == "0") {
          selectedFromDate = DateFormat(dateTimeFormat).format(pickedDate!);
          fromDateController.text = formattedDate;
        } else {
          selectedToDate = DateFormat(dateTimeFormat).format(pickedDate!);
          toDateController.text = formattedDate;
        }
      });
    }
  }

  reasonForLeave() {
    return Container(
      height: 50,
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
            size: 20,
          ),
          border: InputBorder.none,
          hintText: "Reason",
          hintStyle: TextStyle(color: AppColor.themeColor,fontSize: 12),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget assginToSpinnerWidget(BuildContext context,
      List<Activeemployee> activeemployee, String perInCharge) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SearchField<List<Activeemployee>>(
        suggestions: activeemployee
                .map(
                  (activeemployee) => SearchFieldListItem<List<Activeemployee>>(
                    activeemployee.ename,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: robotoTextWidget(
                          textval: activeemployee.ename,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                .toList()
            ,
        searchStyle: const TextStyle(
            fontSize: 12,
            color: AppColor.themeColor,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600),
        searchInputDecoration: const InputDecoration(
          hintText: "Assign Charge To",
          hintStyle: TextStyle(
              color: AppColor.themeColor, fontWeight: FontWeight.normal,fontSize: 12),
          prefixIcon: Icon(
            Icons.person,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
        ),
        onSubmit: (String value) {
          setState(() {
              if (perInCharge == "0") {
                perInCharge1 = value;
              } else if (perInCharge == "1") {
                perInCharge2 = value;
              } else if (perInCharge == "2") {
                perInCharge3 = value;
              } else if (perInCharge == "3") {
                perInCharge4 = value;
              }

          });
        },
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

  void Validation() {
    selectedLeaveType ??= "";
    if (selectedLeaveType!.isEmpty) {
      Utility().showToast("Please Select Leave Type");
    }  else if (fromDateController.text.toString().isEmpty) {
      Utility().showToast("Please select leave from date");
    }  else if (toDateController.text.toString().isEmpty) {
      Utility().showToast("Please select leave to date");
    }  else if (reason.text.toString().isEmpty) {
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
    dynamic response = await HTTP.get(createLeaveAPI(
        sharedPreferences.getString(userID).toString(),
        selectedLeaveType.toString(),
        dayTypeSpinner!,
        selectedFromDate!,
        selectedToDate!,
        reason.text.toString(),
        perInCharge1.toString(),
        perInCharge2.toString(),
        perInCharge3.toString(),
        perInCharge4.toString()));
    if (response != null && response.statusCode == 200) {

      Iterable l = json.decode(response.body);
      List<LeaveRequestModelResponse> leave =
          List<LeaveRequestModelResponse>.from(
              l.map((model) => LeaveRequestModelResponse.fromJson(model)));
      if (leave[0].name.compareTo("Leave request created") == 0) {
        Utility().showToast(leave[0].name);
        Navigator.of(context).pop();
      } else {
        Utility().showToast(leave[0].name);
      }
    }
  }
}
