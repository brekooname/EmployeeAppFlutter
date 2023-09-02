import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import '../Util/utility.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/APIDirectory.dart';
import 'model/TaskListModel.dart';

class TaskListWidget extends StatefulWidget {
  TaskListWidget(
      {Key? key,
      required this.selectedFromDate,
      required this.selectedToDate,
      required this.selectedSubDepartmentCode,
      required this.selectedEmployeeCode,
      required this.type})
      : super(key: key);

  String selectedFromDate,
      selectedToDate,
      selectedSubDepartmentCode,
      selectedEmployeeCode,
      type;

  @override
  State<TaskListWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskListWidget> {
  bool isLoading = false;

  List<Response> taskList = [];
  late int selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveTaskList();
  }

  void retrieveTaskList() {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        getTaskListAPI();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.themeColor,
            ),
          ),
          title: robotoTextWidget(
              textval: taskDetails,
              colorval: AppColor.themeColor,
              sizeval: 16,
              fontWeight: FontWeight.bold),
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.blue.shade800],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.2, 0.8],
                  ),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildPosts(context)),
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 3),
                () {
                  retrieveTaskList();
                },
              );
            }));
  }

  Widget _buildPosts(BuildContext context) {
    if (taskList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: taskList.length,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Wrap ListItem(int index) {
    return Wrap(children: [
      Card(
        color: AppColor.whiteColor,
        elevation: 10,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: AppColor.greyBorder,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Align(
              alignment: Alignment.topLeft,
              child: taskList[index].status.isEmpty
                  ? loadSvg('assets/svg/pending_task.svg')
                  : loadSvg('assets/svg/completed_task.svg'),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      robotoTextWidget(
                          textval: 'Document No:-${taskList[index].dno}',
                          colorval: AppColor.themeColor,
                          sizeval: 10,
                          fontWeight: FontWeight.bold),
                      const SizedBox(
                        width: 50,
                      ),
                      robotoTextWidget(
                          textval: 'Dept Name:-${taskList[index].depName}',
                          colorval: AppColor.themeColor,
                          sizeval: 10,
                          fontWeight: FontWeight.bold)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 30,
                    child: robotoTextWidget(
                      textval: 'Task:- ${taskList[index].agenda}',
                      colorval: AppColor.themeColor,
                      sizeval: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      robotoTextWidget(
                          textval: 'From Date:-${taskList[index].comDateFrom}',
                          colorval: AppColor.themeColor,
                          sizeval: 10,
                          fontWeight: FontWeight.bold),
                      const SizedBox(
                        width: 50,
                      ),
                      robotoTextWidget(
                          textval: 'To Date:-${taskList[index].comDateTo}',
                          colorval: AppColor.themeColor,
                          sizeval: 10,
                          fontWeight: FontWeight.bold)
                    ],
                  ),
                ]),
          ]),
        ),
      ),
    ]);
  }

  SizedBox NoDataFound() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Container(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(30, 136, 229, .5),
                    blurRadius: 20,
                    offset: Offset(0, 10))
              ]),
          child: Align(
            alignment: Alignment.center,
            child: robotoTextWidget(
                textval: noDataFound,
                colorval: AppColor.themeColor,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        )));
  }

  Future<void> getTaskListAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    dynamic res = await HTTP.get(getTaskList(
        widget.selectedSubDepartmentCode,
        widget.selectedEmployeeCode,
        widget.selectedFromDate,
        widget.selectedToDate,
        widget.type));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      TaskListModel taskListModel = TaskListModel.fromJson(jsonData);
      if (taskListModel.status.toString() == 'True') {
        taskList = taskListModel.response;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  loadSvg(String svg) {
    return SvgPicture.asset(svg, width: 30, height: 30);
  }
}
