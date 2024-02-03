import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/task/model/taskrequest.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shakti_employee_app/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/DepartmentModel.dart';
import 'model/taskresponse.dart';

class TaskRequestScreen extends StatefulWidget {
  List<Activeemployee> activeemployeeList = [];

  TaskRequestScreen({Key? key, required this.activeemployeeList})
      : super(key: key);

  @override
  State<TaskRequestScreen> createState() => _TaskRequestScreenState();
}

class _TaskRequestScreenState extends State<TaskRequestScreen> {
  bool isLoading = false,isLoading1 = false;
  List<TaskRequest> taskData = [];
  TextEditingController taskDes = TextEditingController();
  TextEditingController selectedAssginTo = TextEditingController();

  String? currentDate, currentTime;
  DateTime datefrom = DateTime.now(), dateto = DateTime.now();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTime? pickedDate;
  String? taskSpinner, selectedDepartmentCode, dateTimeFormat = "dd.MM.yyyy";
  List<Response> departmentList = [];
  String returnableSpinner = 'DRC-Daily Review Committee (YTT)';
  String? selectedFromDate, selectedToDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        getDepartmentList();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });

    setState(() {
      currentDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
      currentTime = DateFormat("hh:mm:ss").format(DateTime.now());
      selectedFromDate = DateFormat(dateTimeFormat).format(DateTime.now());
      selectedToDate = DateFormat(dateTimeFormat).format(DateTime.now());
      fromDateController.text =
          DateFormat(dateTimeFormat).format(DateTime.now());
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
            textval: taskRequest,
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
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
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                departmentDropdown(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    datePickerWidget(selectedFromDate!, fromDateController, "0"),
                    datePickerWidget(selectedToDate!, toDateController, "1")
                  ],
                ),
                textFeildWidget(taskDesc, taskDes),
                assginToSpinnerWidget(context, widget.activeemployeeList),
                submitWidget(),
              ],
            ),
          ),
        ),
        Center(
          child: isLoading1 ? const CircularProgressIndicator(
            color: Colors.indigo,
          )
              : const SizedBox(),
        ),
      ],)
    );
  }

  textFeildWidget(String hinttxt, TextEditingController visitPlace) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: visitPlace,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.notes_outlined,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: hinttxt,
          hintStyle: const TextStyle(
              color: AppColor.themeColor,
              fontSize: 13,
              fontWeight: FontWeight.normal),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  submitWidget() {
    return GestureDetector(
        onTap: () {
          Validation();
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
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

  Future<void> Validation() async {

    if (selectedDepartmentCode == null || selectedDepartmentCode!.isEmpty) {
      Utility().showToast(pleaseSelectDepartment);
    } else if (taskDes.text.toString().isEmpty) {
      Utility().showToast(pleaseEnterTask);
    } else if (selectedAssginTo.text.toString().isEmpty) {
      Utility().showToast(pleaseEnterPersonCharge);
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Utility().checkInternetConnection().then((connectionResult) {
        if (connectionResult) {

          taskData.add(TaskRequest(
              pernr: sharedPreferences.getString(userID).toString(),
              budat: currentDate!,
              time: currentTime!,
              description: taskDes.text.toString(),
              assignTo: selectedAssginTo.text.toString(),
              dateFrom: fromDateController.text.toString(),
              dateTo: toDateController.text.toString(),
              department: selectedDepartmentCode.toString()));

          String value = convert.jsonEncode(taskData).toString();
          print("Parameter Value===>${value.toString()}");
          createTask(value);
        } else {
          Utility()
              .showInSnackBar(value: checkInternetConnection, context: context);
        }
      });

    }
  }

  departmentDropdown() {
    return SizedBox(
        height: 50,
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
              hintText: selectDepartment,
              fillColor: Colors.white),
          value: selectedDepartmentCode,
          validator: (value) => value == null || value.isEmpty
              ? 'Please select the department'
              : "",
          items: departmentList
              .map((department) => DropdownMenuItem(
                  value: department.departName,
                  child: robotoTextWidget(
                      textval: department.departName,
                      colorval: AppColor.themeColor,
                      sizeval: 11,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedDepartmentCode = value.toString();
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
        firstDate: value == "0"
            ? DateTime.now()
            : selectedFromDate !=
                    DateFormat(dateTimeFormat).format(DateTime.now())
                ? DateTime(2023)
                : DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
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

  Widget assginToSpinnerWidget(
      BuildContext context, List<Activeemployee> activeemployee) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SearchField<List<Activeemployee>>(
        controller: selectedAssginTo,
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
              fontSize: 13,
              fontWeight: FontWeight.normal),
          prefixIcon: const Icon(
            Icons.person,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
        ),
        onSubmit: (String value) {
          setState(() {
            selectedAssginTo.text = value.toString();
          });
        },
      ),
    );
  }

  Future<void> createTask(String value) async {
    var jsonData = null;
    setState(() {
      isLoading = true;
    });
    dynamic response = await HTTP.get(createTaskAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      TaskRespons taskRespons = TaskRespons.fromJson(jsonData);
      if (taskRespons.dataSuccess[2].syncData == "EMP_TASK" &&
          taskRespons.dataSuccess[2].value == "Y") {
        Utility().showToast(taskAssgined);
        Navigator.of(context).pop();
        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast(somethingWentWrong);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showToast(somethingWentWrong);
    }
  }

  getDepartmentList() async {

    setState(() {
      isLoading1 = true;
    });
    dynamic res = await HTTP.get(getDepartment());
    var jsonData = null;
    departmentList = [];
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      DepartmentModel departmentModel = DepartmentModel.fromJson(jsonData);
      if (departmentModel.status.toString() == "True") {
        setState(() {
          departmentList = departmentModel.response;
        });

        setState(() {
          isLoading1 =false;
        });
      }
    }else{

      setState(() {
        isLoading1 =false;
      });
    }
  }
}
