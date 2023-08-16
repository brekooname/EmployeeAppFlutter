import 'dart:convert' as convert;
import 'package:shakti_employee_app/home/home_page.dart';
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

import '../Util/utility.dart';
import 'model/taskresponse.dart';

class TaskApproved extends StatefulWidget {

  List<PendingTask> pendingTaskList = [];
  List<Activeemployee> activeemployeeList = [];

  TaskApproved({Key? key, required this.pendingTaskList ,required this.activeemployeeList}) : super(key: key);

  @override
  State<TaskApproved> createState() => _TaskApprovedState();
}

class _TaskApprovedState extends State<TaskApproved> {
  bool isLoading = false;
  late int selectedIndex;
  List<CompleteTaskRequest> completeTaskData = [];
  String ? selectedAssginTo;

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
              height: 270,
              padding: const EdgeInsets.all(5),
              color: AppColor.whiteColor,
              child: Stack(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayWidget(docNo, widget.pendingTaskList[index].dno),
                    SizedBox(height: 10,),
                    displayWidget(mrcType,  widget.pendingTaskList[index].mrct1),
                    SizedBox(height: 10,),
                    displayWidget(assigner,  widget.pendingTaskList[index].asgnr1),
                    SizedBox(height: 10,),
                    taskDescWidget(desc,  widget.pendingTaskList[index].agenda),
                    Row(
                      children: [
                        displayWidget(dateFrom,   widget.pendingTaskList[index].comDateFrom),
                        SizedBox(
                          width: 35,
                        ),
                        displayWidget(dateTo,   widget.pendingTaskList[index].comDateTo),
                      ],
                    ),
                    assginToSpinnerWidget(context,widget.activeemployeeList),
                    SizedBox(height: 10,),

                    submitWidget(widget.pendingTaskList[index].dno, widget.pendingTaskList[index].srno),
                  ],
                ),
              ]
            )
          )
      ),
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
              child: Align(
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
          const SizedBox(height: 5,),
          robotoTextWidget(textval: txt, colorval: Colors.black, sizeval: 10, fontWeight: FontWeight.w400)
        ],
      ),
    );
  }

  Widget dialogue_removeDevice(BuildContext context) {

    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                appName,
                style: const TextStyle(
                    color: AppColor.themeColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "removeDeviceConfirmation",
              style: const TextStyle(
                  color: AppColor.themeColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: cancel,
                      colorval: AppColor.darkGrey,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    //  removeDeviceAPI();

                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: confirm,
                      colorval: AppColor.whiteColor,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }

  displayWidget(String title , String value) {
    return  Row(
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
    );
  }

  taskDescWidget(String title , String value) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        robotoTextWidget(
          textval: title,
          colorval: AppColor.themeColor,
          sizeval: 14.0,
          fontWeight: FontWeight.bold,
        ),

        Container(
          width: 240,
          height: 30,
          child:  Flexible(
            child: robotoTextWidget(
              textval: value,
              colorval:  Colors.black,
              sizeval: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  submitWidget(String dno, String srno) {
    return  InkWell(
        onTap: () {
          completeTaskData.clear();
          completeTaskData.add(CompleteTaskRequest(dno: dno, srno: srno, checker: selectedAssginTo.toString(), remark: ""));

          String value =  convert.jsonEncode(completeTaskData).toString();
          closeCompleteTask(value);
        },
        child: Container(
          height: 50,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: isLoading
                ? Container(
              height: 30,
              width: 30,
              child:
                   const CircularProgressIndicator(
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
   var jsonData = null;

   dynamic response = await HTTP.get(completeTaskAPI(value));
   if (response != null && response.statusCode == 200) {

     jsonData = convert.jsonDecode(response.body);
     TaskRespons taskRespons = TaskRespons.fromJson(jsonData);


     if(taskRespons.dataSuccess[3].syncData == "EMP_TASK_COMPLETE" && taskRespons.dataSuccess[3].value == "Y"){
       Utility().showToast(taskClosed);
       Navigator.of(context).pop();
     }else
     {
       Utility().showToast(somethingWentWrong);
     }
   }else{
     Utility().showToast(somethingWentWrong);
   }
 }

  Widget assginToSpinnerWidget(BuildContext context, List<Activeemployee> activeemployee) {
    return  Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      child: SearchField< List<Activeemployee>>(
        suggestions: activeemployee
            .map(
              (activeemployee) => SearchFieldListItem< List<Activeemployee>>(
            activeemployee.ename,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Text(activeemployee.ename, style: TextStyle(fontWeight: FontWeight.normal, color: AppColor.themeColor ),),
            ),
          ),
        ).toList(),
        searchInputDecoration: InputDecoration(
          hintText: "Assign Charge To",
          hintStyle: TextStyle(color: AppColor.themeColor, fontSize: 13, fontWeight: FontWeight.normal),
          prefixIcon: Icon(Icons.person, color: AppColor.themeColor, size: 20,),
          border: InputBorder.none,
        ),
        onSubmit: (String value) {
          setState(() {
            selectedAssginTo = value.toString();
          });

          print("submitted\n ${value}"); },
      ),

    );
  }


}

