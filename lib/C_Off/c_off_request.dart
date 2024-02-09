import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/C_Off/model/c_offRequest.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../home/model/ScyncAndroidtoSAP.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/APIDirectory.dart';
import '../webservice/constant.dart';
import 'model/c_offDateListRes.dart' as cOffList;
import 'model/c_offRequestResponse.dart';

class coffRequestWidget extends StatefulWidget {
  List<Activeemployee> activeemployeeList = [];

  coffRequestWidget({Key? key, required this.activeemployeeList})
      : super(key: key);

  @override
  State<coffRequestWidget> createState() => _coffRequestWidgetState();
}

class _coffRequestWidgetState extends State<coffRequestWidget> {
  List<cOffList.Response> cOffDateList = [];
  List<coffRequest> cOffRequestList = [];
  TextEditingController reasonController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController responsiblePerson1 = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  
  String dateFormat = "dd/MM/yyyy", timeFormat = "HH:mm:ss";
  String? selectedCOffDate, selectedDate, dayTypeSpinner, totalHours;
  int? selectedCOffIndex;
  bool isLoading = false;
  bool isLoadingSubmit = false;
  
  DateTime? pickedDate;
  late SharedPreferences sharedPreferences;
  var dayTypeList = [
    fullDayMore,
    halfDay,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedDate = DateFormat(dateFormat).format(DateTime.now());
      dateController.text = DateFormat(dateFormat).format(DateTime.now());
    });
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        cOffDaysListApiCall();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
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
              textval: compensatoryOffRequest,
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
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    coffDateListWidget(),
                    datePickerWidget(selectedDate!, dateController),
                    dayTypeSpinnerWidget(),
                    dayTypeSpinner == halfDay
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              timePickerWidget(
                                  selectFromTime, fromTimeController, "0"),
                              timePickerWidget(
                                  selectToTime, toTimeController, "1")
                            ],
                          )
                        : Container(),
                    reasonControllerForCOff(),
                    assginToSpinnerWidget(context, widget.activeemployeeList),
                    submitWidget(),
                  ],
                ),
              ),
            ),
            Center(
                child: isLoading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox()),
          ],
        ));
  }

  coffDateListWidget() {
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
              hintText: selectCOffDate,
              fillColor: Colors.white),
          value: selectedCOffDate,
          validator: (value) =>
              value == null || value.isEmpty ? selectLeaveType : "",
          items: cOffDateList
              .map((listItem) => DropdownMenuItem(
                  value: listItem.begdat,
                  child: robotoTextWidget(
                      textval: listItem.begdat,
                      colorval: AppColor.themeColor,
                      sizeval: 12,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedCOffDate = value.toString();
              if (cOffDateList[0].begdat == value) {
                totalHours = cOffDateList[0].totdz;
              } else {
                totalHours = cOffDateList[1].totdz;
              }
            });
          },
        ));
  }

  datePickerWidget(String fromTO, TextEditingController dateController) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10),
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
            Expanded(
                child: TextField(
              controller: dateController,
              maxLines: 1,
              showCursor: false,
              enabled: false,
              // textAlign: TextAlign.center,
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

  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat(dateFormat).format(pickedDate!);
        dateController.text = selectedDate!;
        print("selectedDate ${selectedDate}");
        print("dateController ${dateController.text}");
      });
    }
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
      ),
    );
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

  reasonControllerForCOff() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: reasonController,
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

  Widget assginToSpinnerWidget(
      BuildContext context, List<Activeemployee> activeemployee) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SearchField<List<Activeemployee>>(
        controller: responsiblePerson1,
        suggestions: activeemployee
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
              fontSize: 12,
              fontWeight: FontWeight.normal),
          prefixIcon: const Icon(
            Icons.person,
            size: 20,
            color: AppColor.themeColor,
          ),
          border: InputBorder.none,
        ),
        onSubmit: (String value) {
          setState(() {
            responsiblePerson1.text = value.toString();
          });
        },
      ),
    );
  }

  submitWidget() {
    return GestureDetector(
        onTap: () {
          validation();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: isLoadingSubmit
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

  Future<void> validation() async {
    if (selectedCOffDate == null || selectedCOffDate!.isEmpty) {
      Utility().showToast(selectCOffDate);
    } else if (dateController.text
        .toString()
        .isEmpty) {
      Utility().showToast(selectDate);
    } else if (dayTypeSpinner == null || dayTypeSpinner!.isEmpty) {
      dayTypeSpinner = null;
      Utility().showToast(validDayType);
    } else if (reasonController.text
        .toString()
        .isEmpty) {
      Utility().showToast(vaildRaseon);
    } else if (responsiblePerson1.text
        .toString()
        .isEmpty) {
      Utility().showToast(vaildPerson);
    } else if (responsiblePerson1.text
        .contains(sharedPreferences.getString(userID).toString())) {
      Utility().showToast(errorMessg);
    } else if (totalHours!.compareTo("07:00:00") >= 0 &&
        dayTypeSpinner == halfDay) {
      Utility().showToast(wrongDayError);
    } else if (totalHours!.compareTo("03:30:00") >= 0 &&
        totalHours!.compareTo("07:00:00") <= 0 &&
        dayTypeSpinner == fullDayMore) {
      Utility().showToast(wrongDayError2);
    } else {
      if (dayTypeSpinner == halfDay) {
        if (fromTimeController.text.toString().isEmpty) {
          Utility().showToast(selectFromTime);
        } else if (toTimeController.text.toString().isEmpty) {
          Utility().showToast(selectToTime);
        } else {
          cOffApi(fromTimeController.text.toString(),
              toTimeController.text.toString(), "04:00:00");
        }
      } else {
        cOffApi("08:30:00", "17:00:00", "08:00:00");
      }
    }
  }

  void cOffApi(String indz, String iodz, String totdz) {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        cOffRequestList.clear();
        cOffRequestList.add(coffRequest(
            pernr: sharedPreferences.getString(userID).toString(),
            coffDate: selectedCOffDate!,
            indz: indz,
            iodz: iodz,
            totdz: totdz,
            applyDate: selectedDate!,
            pernr2: responsiblePerson1.text.toString(),
            reason: reasonController.text.toString(),
            leavetype: dayTypeSpinner!));
        String value = convert.jsonEncode(cOffRequest).toString();
        print("Parameter Value===>${value.toString()}");
        cOffReqAPI(value);
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Future<void> cOffDaysListApiCall() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    var jsonData = null;

    dynamic response = await HTTP.get(getCOffDateListApi(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      cOffList.coffDateList cOffDateListResponse =
          cOffList.coffDateList.fromJson(jsonData);

      if (cOffDateListResponse.status == "true") {
        cOffDateList = cOffDateListResponse.response;
        print("ListCoff=== ${cOffDateList}");
        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast(cOffDateListResponse.message);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> cOffReqAPI(String value) async {
    setState(() {
      isLoadingSubmit = true;
    });
    var jsonData = null;

    dynamic response = await HTTP.get(cOffReqApi(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      coffRequestResponse saveResponse = coffRequestResponse.fromJson(jsonData);

      if (saveResponse.status == "true") {
        Utility().showToast(saveResponse.message);
        if (mounted) {
          setState(() {
            isLoadingSubmit = false;
          });
        }
        Navigator.pop(context);
        print("saveResponse=== ${saveResponse.message}");
      } else {
        Utility().showToast(saveResponse.message);
        setState(() {
          isLoadingSubmit = false;
        });
      }
    }
  }
}
