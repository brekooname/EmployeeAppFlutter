import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/all_task/task_list_widget.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../task/model/DepartmentModel.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/APIDirectory.dart';
import '../webservice/constant.dart';
import 'model/TaskCountListModel.dart';
import 'model/taskCountModel.dart';

class MyTaskListWidget extends StatefulWidget {
  MyTaskListWidget({Key? key}) : super(key: key);

  @override
  State<MyTaskListWidget> createState() => _MyTaskListWidgetState();
}

class _MyTaskListWidgetState extends State<MyTaskListWidget> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  bool isLoading = false, showTable = false;
  List<TaskCountList> taskCountList = [];
  late TaskCountList taskList;
  List<Response> departmentList = [];
  DateTime? pickedDate;
  String? selectedFromDate,
      selectedToDate,
      selectedSubDepartmentCode,
      selectedEmployeeCode;
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        getDepartmentList();
        getEmployyeCode();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });

    setState(() {
      selectedFromDate = DateFormat('yyyyMMdd').format(DateTime.now());
      selectedToDate = DateFormat('yyyyMMdd').format(DateTime.now());
      fromDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      toDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
              textval: myTask,
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
        body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 3),
                () {
                  getDepartment();
                },
              );
            },
            child: Stack(children: [
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  color: AppColor.whiteColor,
                  child: Column(
                    children: [
                      DepartmentDropdown(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          datePickerWidget(
                              selectFromDate, fromDateController, "0"),
                          datePickerWidget(selectToDate, toDateController, "1")
                        ],
                      ),
                      searchBtnWidget(),
                      const SizedBox(
                        height: 10,
                      ),
                      showTable
                          ? _buildTable(context)
                          : const robotoTextWidget(
                              textval: 'No Task Available',
                              colorval: AppColor.blackColor,
                              sizeval: 12,
                              fontWeight: FontWeight.bold),
                    ],
                  ))
            ])));
  }

  DepartmentDropdown() {
    return Container(
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
          value: selectedSubDepartmentCode,
          validator: (value) => value == null || value.isEmpty
              ? 'Please select the sub-department'
              : "",
          items: departmentList
              .map((subDepartment) => DropdownMenuItem(
                  value: subDepartment.departName,
                  child: robotoTextWidget(
                      textval: subDepartment.departName,
                      colorval: AppColor.themeColor,
                      sizeval: 11,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedSubDepartmentCode = value.toString();
            });
          },
        ));
  }

  getDepartmentList() async {
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
      }
    }
  }

  _buildTable(BuildContext context) {
    return Scrollbar(
        controller: _vertical,
        thumbVisibility: true,
        trackVisibility: true,
        notificationPredicate: (notif) => notif.depth == 1,
        child: SingleChildScrollView(
            controller: _horizontal,
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Center(
                      child: setTitle("Name"),
                    ),
                    numeric: false,
                  ),
                  DataColumn(
                      label: Center(child: setTitle("Pending Task")),
                      numeric: true),
                  DataColumn(
                      label: Center(child: setTitle("Completed Task")),
                      numeric: true),
                  DataColumn(
                      label: Center(child: setTitle("Total Task")),
                      numeric: true),
                ],
                rows: taskCountList
                    .map(
                      (taskCountList) => DataRow(
                        cells: [
                          DataCell(setValue(taskCountList.depName ?? "", 0)),
                          DataCell(setValue(
                              taskCountList.pendingTaskCount ?? "", 1)),
                          DataCell(setValue(
                              taskCountList.completedTaskCount ?? "", 2)),
                          DataCell(
                              setValue(taskCountList.totalTaskCount ?? "", 3)),
                        ],
                      ),
                    )
                    .toList()))
    );
  }

  Widget setTitle(String value) {
    return robotoTextWidget(
        textval: value,
        colorval: AppColor.themeColor,
        sizeval: 14,
        fontWeight: FontWeight.bold);
  }

  Widget setValue(String value, int position) {
    return TextButton(
        child: robotoTextWidget(
            textval: value,
            colorval: Colors.black,
            sizeval: 12,
            fontWeight: FontWeight.w600),
        onPressed: () async {
          if (position == 1) {
              moveToNextScreen("PEND");
          }
          if (position == 2) {
             moveToNextScreen("COMPLETE");
          }
          if (position == 3) {
            moveToNextScreen("TOTAL");
          }
        });
  }

  void moveToNextScreen(String type) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => TaskListWidget(
                  selectedFromDate: selectedFromDate!,
                  selectedToDate: selectedToDate!,
                  selectedSubDepartmentCode: selectedSubDepartmentCode!,
                  selectedEmployeeCode: selectedEmployeeCode!,
                  type: type,
                )),
        (Route<dynamic> route) => true);
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
        //get today's date

        firstDate: value == "0"
            ? DateTime(2000)
            : selectedFromDate != DateFormat('yyyyMMdd').format(DateTime.now())
                ? DateTime(2000)
                : DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());
    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate!);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        if (value == "0") {
          selectedFromDate = DateFormat('yyyyMMdd').format(pickedDate!);
          fromDateController.text = formattedDate;
        } else {
          selectedToDate = DateFormat('yyyyMMdd').format(pickedDate!);
          toDateController.text = formattedDate;
        }
      });
    }
  }

  searchBtnWidget() {
    return GestureDetector(
        onTap: () {
          Utility().checkInternetConnection().then((connectionResult) {
            if (connectionResult) {
              selectedFromDate ??= "";
              selectedToDate ??= "";
              if (selectedFromDate!.isEmpty) {
                Utility()
                    .showInSnackBar(value: selectFromDate, context: context);
              } else if (selectedToDate!.isEmpty) {
                Utility().showInSnackBar(value: selectToDate, context: context);
              } else {
                getTaskCount();
              }
            } else {
              Utility().showInSnackBar(
                  value: checkInternetConnection, context: context);
            }
          });
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 30, bottom: 30),
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
                    textval: search,
                    colorval: Colors.white,
                    sizeval: 14,
                    fontWeight: FontWeight.bold),
          ),
        ));
  }

  getTaskCount() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    dynamic res = await HTTP.get(getTotalTaskCountList(
        selectedSubDepartmentCode ?? "",
        selectedEmployeeCode ?? "",
        selectedFromDate ?? "",
        selectedToDate ?? ""));

    var jsonData = null;
    taskCountList = [];
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      TaskCountModel taskCountModel = TaskCountModel.fromJson(jsonData);
      if (taskCountModel.status.toString() == "true") {
        if (taskCountModel.pending.isNotEmpty ||
            taskCountModel.completed.isNotEmpty ||
            taskCountModel.total.isNotEmpty) {
          if (taskCountModel.pending.isNotEmpty &&
              taskCountModel.completed.isNotEmpty &&
              taskCountModel.total.isNotEmpty) {
            setterGatterTask(taskCountModel, 0);
          } else if (taskCountModel.pending.isNotEmpty &&
              taskCountModel.completed.isNotEmpty) {
            setterGatterTask(taskCountModel, 1);
          } else if (taskCountModel.completed.isNotEmpty &&
              taskCountModel.total.isNotEmpty) {
            setterGatterTask(taskCountModel, 2);
          } else if (taskCountModel.total.isNotEmpty &&
              taskCountModel.pending.isNotEmpty) {
            setterGatterTask(taskCountModel, 3);
          } else if (taskCountModel.pending.isEmpty &&
              taskCountModel.completed.isEmpty &&
              taskCountModel.total.isEmpty) {
            showTable = false;
          }
        }
      } else {
        showTable = false;
      }
      setState(() {
        isLoading = false;
      });
    } else {
      if (mounted) {
        setState(() {
          showTable = false;
          isLoading = false;
        });
      }
    }
  }

  void setterGatterTask(TaskCountModel taskCountModel, int i) {
    if (i == 0) {
      taskList = TaskCountList(
          pernr: taskCountModel.pending.first.pernr ?? "",
          depName: taskCountModel.pending.first.depName ?? "",
          pendingTaskCount: taskCountModel.pending.first.count ?? "",
          totalTaskCount: taskCountModel.total.first.count ?? "",
          completedTaskCount: taskCountModel.completed.first.count ?? "");
    }
    if (i == 1) {
      taskList = TaskCountList(
          pernr: taskCountModel.pending.first.pernr ?? "",
          depName: taskCountModel.pending.first.depName ?? "",
          pendingTaskCount: taskCountModel.pending.first.count ?? "",
          totalTaskCount: "0",
          completedTaskCount: taskCountModel.completed.first.count ?? "");
    }
    if (i == 2) {
      taskList = TaskCountList(
          pernr: taskCountModel.completed.first.pernr ?? "",
          depName: taskCountModel.completed.first.depName ?? "",
          pendingTaskCount: "0",
          totalTaskCount: taskCountModel.total.first.depName ?? "",
          completedTaskCount: taskCountModel.completed.first.count ?? "");
    }
    if (i == 3) {
      taskList = TaskCountList(
          pernr: taskCountModel.pending.first.pernr ?? "",
          depName: taskCountModel.pending.first.depName ?? "",
          pendingTaskCount: taskCountModel.pending.first.count ?? "",
          totalTaskCount: taskCountModel.total.first.depName ?? "",
          completedTaskCount: "0");
    }

    setState(() {
      taskCountList.add(taskList);
      showTable = true;
    });
  }

  Future<void> getEmployyeCode() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      selectedEmployeeCode = sharedPreferences.getString(userID)!;
    });
  }
}
