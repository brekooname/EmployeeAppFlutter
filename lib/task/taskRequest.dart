import 'dart:convert' as convert;
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shakti_employee_app/task/model/taskrequest.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/taskresponse.dart';

class TaskRequestScreen extends StatefulWidget {

  List<Activeemployee> activeemployeeList = [];
  TaskRequestScreen({Key? key , required this.activeemployeeList} ) : super(key: key);

  @override
  State<TaskRequestScreen> createState() => _TaskRequestScreenState();
}

class _TaskRequestScreenState extends State<TaskRequestScreen> {

  bool isLoading = false;
  List<TaskRequest> taskData = [];
  TextEditingController taskDes = TextEditingController();
  String? currentDate, currentTime;
  DateTime datefrom = DateTime.now(), dateto = DateTime.now();
  String ?  selectedAssginTo;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTime? pickedDate;
  String? taskSpinner,departmentSpinner,dateTimeFormat ="dd/MM/yyyy";



  String returnableSpinner = 'DRC-Daily Review Committee (YTT)';
  // List of items in our dropdown menu
  var taskList = [
    'DRC-Daily Review Committee (YTT)',
    'WRC-Weekly Review Committee',
    'MINI-Monthly Review Committee',
    'WOBJ-Weekly Object',
    'MOBJ-Monthly Object',
    'YOBJ-Yearly Object',
    'PJOB-Periodic Task'
  ];

  String?  selectedFromDate, selectedToDate;

  // List of items in our dropdown menu
  var TypeList = [
    'Department',
     '1-ALL',
     '2-SAP/IT',
     '3-HR/ADMIN',
     '4-FINANCE',
     '5-DOMESTIC SALES',
     '6-INTERNATIONAL BUSINESS',
      '7-VINTEX',
       '8-STORES',
       '9-MATERIAL MANAGEMENT[PURC]',
      ' 10-MAINTENANCE',
       '11-1200 PUMP',
       '12-1199 MOTOR V6, V8 TO V12',
       '13-1201 MOTOR V4',
       '14-1198 SRN',
      ' 15-1196 SMG',
       '16-1100 SEZ ALL',
       '17-VENDOR DEVLOPMENT[PURCHA]',
       '18-MARKETING',
       '19-QUALITY/TESTING',
       '20-PRODUCT ENGG.',
       '21-PACKING/DISPATCH',
       '23-AUDIT',
       '25-SERVICE',
       '27-R/D',
      ' 28-1197 SHOS/SNB',
       '29-1300 NEW PLANT',
       '32-1194-CNC',
       '34-SOLAR SALES (GOVT.)',
       '35-MR DEPT.',
       '36-IMPORT DEPT.',
       '37-SOLAR SALES (OEM)',
       '38-INDUSTRIAL SALES',
       '41-7000SHAKTI IRRIGATION-RAU',
       '42-7010SHAKTI IRRIGATION-DRI',
       '46-PRODUCT MANAGEMENT',
       '47-CHANNEL MANAGEMENT',
       '48-VECTOR MOM',
       '49-SOLAR NABARD',
       '50-SOLAR MARKETING'
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      currentDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
      currentTime = DateFormat("hh:mm:ss").format(DateTime.now());
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
      appBar:AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: taskRequest,
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );}
        ),
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: double.infinity,
        width: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              MRCTypeSpinnerWidget(),
              SizedBox(height: 10,),
              departmentTypeSpinnerWidget(),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  datePickerWidget(
                      selectedFromDate!, fromDateController, "0"),
                  datePickerWidget(
                      selectedToDate!, toDateController, "1")
                ],
              ),
              textFeildWidget("Task Description", taskDes),
              assginToSpinnerWidget(context,widget.activeemployeeList),
              submitWidget(),
            ],
          ),
        ),
      ),
    );
  }

  textFeildWidget(String hinttxt, TextEditingController visitPlace) {
    return  Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      child:  TextField(
        controller: visitPlace,
        style: const TextStyle(color: AppColor.themeColor),
        decoration:  InputDecoration(
          prefixIcon: const Icon(
            Icons.notes_outlined,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: hinttxt,
          hintStyle:
          const TextStyle(color: AppColor.themeColor ,fontSize: 13, fontWeight: FontWeight.normal),
        ),
        keyboardType: TextInputType.text,

      ),
    );
  }

  submitWidget() {
    return  GestureDetector(
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

  Future<void> Validation() async {
    departmentSpinner ??= "";
    taskSpinner ??= "";

    print("taskDec==>${taskDes.text.toString()}");
    if(taskSpinner!.isEmpty) {
      Utility().showToast("Please select task type ");
    }else if(departmentSpinner!.isEmpty) {
      Utility().showToast("Please select Department");
    } else if(taskDes.text.toString().isEmpty ) {
      Utility().showToast("Please enter Task Description");
    } else if(selectedAssginTo!.isEmpty){
      Utility().showToast("Please enter person in charge");
    }else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      taskData.add(TaskRequest(pernr: sharedPreferences.getString(userID).toString() , budat: currentDate!, time: currentTime!, description: taskDes.text.toString(), assignTo: selectedAssginTo.toString(), dateFrom: fromDateController.text.toString(), dateTo: toDateController.text.toString(), mrcType: taskSpinner.toString(), department: departmentSpinner.toString()));

      String value =  convert.jsonEncode(taskData).toString();
      createTask(value);
    }
  }

  MRCTypeSpinnerWidget() {
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
              hintText: 'Select task type',
              fillColor: Colors.white),
          value: taskSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please Select task type' : "",
          items: taskList.map((taskListType) => DropdownMenuItem(
              value: taskListType,
              child: robotoTextWidget(
                  textval: taskListType,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            setState(() {
              taskSpinner = value.toString();
            });
          },
        ));
  }

  departmentTypeSpinnerWidget() {
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
              hintText: 'Select department type',
              fillColor: Colors.white),
          value: departmentSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please Select department type' : "",
          items: TypeList.map((department) => DropdownMenuItem(
              value: department,
              child: robotoTextWidget(
                  textval: department,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),
          onChanged: (Object? value) {
            setState(() {
              departmentSpinner = value.toString();
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


  Future<void> createTask( String value) async {
    var jsonData = null;

    dynamic response = await HTTP.get(createTaskAPI(value));
    if (response != null && response.statusCode == 200) {

      print("response======>${response.toString()}");

      jsonData = convert.jsonDecode(response.body);
      TaskRespons taskRespons = TaskRespons.fromJson(jsonData);

      print("response======>${taskRespons.dataSuccess[2].value.toString()}");
      print("response======>${taskRespons.dataSuccess[2].syncData.toString()}");

      if(taskRespons.dataSuccess[2].syncData == "EMP_TASK" && taskRespons.dataSuccess[2].value == "Y"){

        Utility().showToast("Task has been assigned.");


        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    HomePage( )),
                (route) => true);

      }else
        {
          Utility().showToast("Something went wrong try again.");
        }

    }
  }

}