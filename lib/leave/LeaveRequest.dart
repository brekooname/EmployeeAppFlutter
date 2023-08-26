// ignore_for_file: library_prefixes, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
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
      dateFormat = "dd/MM/yyyy",
      timeFormat = "HH:mm:ss";

  String? selectedLeaveType,
      dayTypeSpinner,
      halfDayTypeSpinner,
      selectedFromDate,
      selectedToDate;
  bool isListVisible = false;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
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
      selectedFromDate = DateFormat(dateFormat).format(DateTime.now());
      selectedToDate = DateFormat(dateFormat).format(DateTime.now());
      fromDateController.text = DateFormat(dateFormat).format(DateTime.now());
      toDateController.text = DateFormat(dateFormat).format(DateTime.now());
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
              dayTypeSpinnerWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  datePickerWidget(selectedFromDate!, fromDateController, "0"),
                  datePickerWidget(selectedToDate!, toDateController, "1")
                ],
              ),
              SizedBox(
                height: 10,
              ),
              dayTypeSpinner == "Half Day"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        timePickerWidget(
                            selectFromTime, fromTimeController, "0"),
                        timePickerWidget(selectToTime, toTimeController, "1")
                      ],
                    )
                  : Container(),
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
    return Container(
        margin: const EdgeInsets.only(top: 10),
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
          value: selectedLeaveType,
          validator: (value) =>
              value == null || value.isEmpty ? selectLeaveType : "",
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
        margin: const EdgeInsets.only(top: 10, bottom: 10),
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
              hintText: selectDayOrMore,
              fillColor: Colors.white),
          value: dayTypeSpinner,
          validator: (value) =>
              value == null || value.isEmpty ? selectDayOrMore : "",
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
                  hintStyle: const TextStyle(color: AppColor.themeColor),
                  border: InputBorder.none),
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: AppColor.themeColor),
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
        firstDate:  DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        if (value == "0") {
          selectedFromDate = DateFormat(dateFormat).format(pickedDate!);
          fromDateController.text = selectedFromDate!;
        } else {
          selectedToDate = DateFormat(dateFormat).format(pickedDate!);
          toDateController.text = selectedToDate!;
        }
      });
    }
  }

  timePickerWidget(
      String fromTO, TextEditingController timeController, String value) {
    return GestureDetector(
      onTap: () {
        _selectTime(value);
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
              Icons.timer_outlined,
              color: AppColor.themeColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                child: TextField(
              controller: timeController,
              maxLines: 1,
              showCursor: false,
              enabled: false,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: fromTO,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: AppColor.themeColor),
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
            ))
          ],
        ),
      ),
    );
  }

  void _selectTime(String value) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Using 24-Hour format
                alwaysUse24HourFormat: false),
            // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
            child: child!);

      },

    );
    if (newTime != null) {
      setState(() {
        if (value == "0") {
          fromTimeController.text = DateFormat(timeFormat)
              .format(DateTime(2019, 08, 1, newTime.hour, newTime.minute));
        } else if (value == "1") {
          toTimeController.text = DateFormat(timeFormat)
              .format(DateTime(2019, 08, 1, newTime.hour, newTime.minute));
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
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.edit_note,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: reasontxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
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
            .toList(),
        searchStyle: const TextStyle(
            fontSize: 12,
            color: AppColor.themeColor,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600),
        searchInputDecoration: InputDecoration(
          hintText: assginCharge,
          hintStyle: const TextStyle(
              color: AppColor.themeColor,
              fontWeight: FontWeight.normal,
              fontSize: 12),
          prefixIcon: const Icon(
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
      Utility().showToast(vaildLeaveType);
    } else if (fromDateController.text.toString().isEmpty) {
      Utility().showToast(vaildLeaveDate);
    } else if (toDateController.text.toString().isEmpty) {
      Utility().showToast(vaildLeaveDateTO);
    } else if (reason.text.toString().isEmpty) {
      Utility().showToast(vaildRaseon);
    } else if (perInCharge1.isEmpty) {
      Utility().showToast(vaildPerson1);
    } else if (perInCharge2.isEmpty) {
      Utility().showToast(vaildPerson2);
    } else {
      if (dayTypeSpinner == "Half Day") {
        if (fromTimeController.text.toString().isEmpty) {
          Utility().showToast(selectFromTime);
        } else if (toTimeController.text.toString().isEmpty) {
          Utility().showToast(selectToTime);
        } else {
          applyLeave();
        }
      } else {
        applyLeave();
      }
    }
  }

  Future<void> applyLeave() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('URLLeave======>${createLeaveAPI(
        sharedPreferences.getString(userID).toString(),
        selectedLeaveType.toString(),
        dayTypeSpinner!,
        selectedFromDate!,
        selectedToDate!,
        fromTimeController.text.toString().isEmpty?"08:30:00":fromTimeController.text.toString(),
        toTimeController.text.toString().isEmpty?"17:00:00":toTimeController.text.toString(),
        reason.text.toString(),
        perInCharge1.toString(),
        perInCharge2.toString(),
        perInCharge3.toString(),
        perInCharge4.toString())}');
  dynamic response = await HTTP.get(createLeaveAPI(
        sharedPreferences.getString(userID).toString(),
        selectedLeaveType.toString(),
        dayTypeSpinner!,
        selectedFromDate!,
        selectedToDate!,
        fromTimeController.text.toString().isEmpty?"08:30:00":fromTimeController.text.toString(),
        toTimeController.text.toString().isEmpty?"17:00:00":toTimeController.text.toString(),
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
        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast(leave[0].name);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }
}
