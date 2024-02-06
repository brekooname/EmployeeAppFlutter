import 'dart:convert' as convert;

import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/task/model/completetaskrequest.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../webservice/constant.dart';
import 'model/taskresponse.dart';

class TaskApproved extends StatefulWidget {
  List<PendingTask> pendingTaskList = [];
  List<Activeemployee> activeemployeeList = [];

  TaskApproved(
      {Key? key,
      required this.pendingTaskList,
      required this.activeemployeeList})
      : super(key: key);

  @override
  State<TaskApproved> createState() => _TaskApprovedState();
}

class _TaskApprovedState extends State<TaskApproved> {
  bool isLoading = false;
  late int selectedIndex;
  List<CompleteTaskRequest> completeTaskData = [];
  String? selectedAssginTo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: closeTask,
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _buildPosts(context)),
    );
  }

  Widget _buildPosts(BuildContext context) {
    if (widget.pendingTaskList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: widget.pendingTaskList.length,
        padding: const EdgeInsets.all(5),
      ),
    );
  }

  Wrap ListItem(int index) {
    return Wrap(children: [
      Card(
          color: AppColor.whiteColor,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.whiteColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            color: AppColor.whiteColor,
            child: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayWidget(docNo, widget.pendingTaskList[index].dno),
                    displayWidget(mrcType, widget.pendingTaskList[index].mrct1),
                    displayWidget(assigner, widget.pendingTaskList[index].asgnr1),
                    taskDescWidget(desc, widget.pendingTaskList[index].agenda),
                    Row(
                      children: [
                        displayWidget(
                            dateFrom, widget.pendingTaskList[index].comDateFrom),
                        const SizedBox(
                          width: 25,
                        ),
                        displayWidget(
                            dateTo, widget.pendingTaskList[index].comDateTo),
                      ],
                    ),
                    assginToSpinnerWidget(context, widget.activeemployeeList),
                    submitWidget(widget.pendingTaskList[index].dno,
                        widget.pendingTaskList[index].srno),
                  ],
                ),
              ),
            ]),
          )),
    ]);
  }

  Widget loadSVG(String svg) {
    return SvgPicture.asset(
      svg,
      width: 13,
      height: 13,
    );
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
          child: const Align(
            alignment: Alignment.center,
            child: robotoTextWidget(
                textval: "noDataFound",
                colorval: AppColor.themeColor,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        )));
  }

  SizedBox IconWidget(String svg, String txt) {
    return SizedBox(
      width: 45,
      child: Column(
        children: [
          SvgPicture.asset(
            svg,
            width: 25,
            height: 25,
          ),
          const SizedBox(
            height: 5,
          ),
          robotoTextWidget(
              textval: txt,
              colorval: Colors.black,
              sizeval: 10,
              fontWeight: FontWeight.w400)
        ],
      ),
    );
  }

  displayWidget(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          robotoTextWidget(
            textval: title,
            colorval: AppColor.themeColor,
            sizeval: 14.0,
            fontWeight: FontWeight.bold,
          ),
          robotoTextWidget(
            textval: value,
            colorval: Colors.black,
            sizeval: 14.0,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  taskDescWidget(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          robotoTextWidget(
            textval: title,
            colorval: AppColor.themeColor,
            sizeval: 14.0,
            fontWeight: FontWeight.bold,
          ),
          Flexible(
            child: robotoTextWidget(
              textval: value,
              colorval: Colors.black,
              sizeval: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  Widget assginToSpinnerWidget(
      BuildContext context, List<Activeemployee> activeemployee) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 3),
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
                activeemployee.ename,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppColor.themeColor),
              ),
            ),
          ),
        )
            .toList(),
        searchInputDecoration: InputDecoration(
          hintText: checkedByPerson,
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
            selectedAssginTo = value.toString();
          });
        },
      ),
    );
  }

  submitWidget(String dno, String srno) {
    return InkWell(
        onTap: () {

          Utility().checkInternetConnection().then((connectionResult) {
            if (connectionResult) {
              completeTaskData.clear();
              completeTaskData.add(CompleteTaskRequest(
                  dno: dno,
                  srno: srno,
                  checker: selectedAssginTo.toString(),
                  remark: ""));

              String value = convert.jsonEncode(completeTaskData).toString();
              closeCompleteTask(value);
            } else {
              Utility()
                  .showInSnackBar(value: checkInternetConnection, context: context);
            }
          });

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

  Future<void> closeCompleteTask(String value) async {
    setState(() {
      isLoading = true;
    });
    var jsonData = null;

    dynamic response = await HTTP.get(completeTaskAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      TaskRespons taskRespons = TaskRespons.fromJson(jsonData);

      if (taskRespons.dataSuccess[3].syncData == "EMP_TASK_COMPLETE" &&
          taskRespons.dataSuccess[3].value == "Y") {
        updateSharedPreference();
      } else {
        Utility().showToast(somethingWentWrong);
        setState(() {
          isLoading = true;
        });
      }
    } else {
      setState(() {
        isLoading = true;
      });
      Utility().showToast(somethingWentWrong);
    }
  }


  updateSharedPreference() async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dynamic response = await HTTP.get(
        SyncAndroidToSapAPI(sharedPreferences.getString(userID).toString()));
    if (response != null && response.statusCode == 200) {
      if(mounted){
        setState(() {
          isLoading = false;
          Utility()
              .setSharedPreference(syncSapResponse, response.body.toString());
        });
      }
      Utility().showToast(taskClosed);
      Navigator.of(context).pop();
    } else {
      setState(() {
        isLoading = false;
      });
      Utility().showToast(somethingWentWrong);
    }
  }
}
