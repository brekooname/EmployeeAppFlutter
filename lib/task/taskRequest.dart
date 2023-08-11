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
  String ? indianFromDate,indianToDate ,selectedAssginTo;
  DateTime selectedDate = DateTime.now();


  String returnableSpinner = 'DRC-Daily Review Committee (YTT)';
  // List of items in our dropdown menu
  var returnableList = [
    'DRC-Daily Review Committee (YTT)',
    'WRC-Weekly Review Committee',
    'MINI-Monthly Review Committee',
    'WOBJ-Weekly Object',
    'MOBJ-Monthly Object',
    'YOBJ-Yearly Object',
    'PJOB-Periodic Task'
  ];

  String typeSpinner = 'Department';

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
    indianFromDate =  DateFormat("dd.MM.yyyy").format(DateTime.now());
    indianToDate =  DateFormat("dd.MM.yyyy").format(DateTime.now());

    currentDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
    currentTime = DateFormat("hh:mm:ss").format(DateTime.now());

    print("Date====${currentDate} Time======>${currentTime} ");
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
            icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            children: [
              MRCTypeSpinnerWidget(),
              departmentTypeSpinnerWidget(),
              const SizedBox(height: 10,),
              datePickerWidget("From Date",indianFromDate.toString()),
              const SizedBox(height: 10,),
              datePickerWidget("To Date",indianToDate.toString()),
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
      margin: const EdgeInsets.all(10),
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
          ),
          border: InputBorder.none,
          hintText: hinttxt,
          hintStyle:
          const TextStyle(color: AppColor.themeColor , fontWeight: FontWeight.normal),
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
          margin: const EdgeInsets.symmetric(
              horizontal: 50),
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
    if(typeSpinner ==  "Department") {
      Utility().showToast("Please select Department");
    }else if(dateto.compareTo(datefrom) < 0) {
      Utility().showToast("To date can not be smaller then From date");
    }else if(taskDes.text.toString().isEmpty ) {
      Utility().showToast("Please enter Task Description");
    } else if(selectedAssginTo!.isEmpty){
      Utility().showToast("Please enter person in charge");
    }else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      taskData.add(TaskRequest(pernr: sharedPreferences.getString(userID).toString() , budat: currentDate!, time: currentTime!, description: taskDes.text.toString(), assignTo: selectedAssginTo.toString(), dateFrom: indianFromDate.toString(), dateTo: indianFromDate.toString(), mrcType: returnableSpinner, department: typeSpinner));

      String value =  convert.jsonEncode(taskData).toString();

      createTask(value);
    }
  }

  MRCTypeSpinnerWidget() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(height: 0,),
          value: returnableSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: returnableList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 17, fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              returnableSpinner = newValue!;
            });
          },
        ),
      ),);
  }

  departmentTypeSpinnerWidget() {
    return  Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(height: 0,),
          value: typeSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: TypeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              typeSpinner = newValue!;
            });
          },
        ),
      ),
    );
  }

  datePickerWidget( String text, String date) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height/20,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.whiteColor,
              ),
              onPressed: () => _selectDate(context,text),
              child:  robotoTextWidget(textval: text, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15.0,),
            robotoTextWidget(textval: date.toString(), colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.normal)
          ],
        ),
      ),

    );
  }


  Widget assginToSpinnerWidget(BuildContext context, List<Activeemployee> activeemployee) {
    return  Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 3),
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
              child:  Text(activeemployee.ename, style: const TextStyle(fontWeight: FontWeight.normal, color: AppColor.themeColor ),),
            ),
          ),
        ).toList(),
        searchInputDecoration: const InputDecoration(
          hintText: "Assign Charge To",
          hintStyle: TextStyle(color: AppColor.themeColor, fontWeight: FontWeight.normal),
          prefixIcon: Icon(Icons.person, color: AppColor.themeColor,),
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

  Future<void> _selectDate(BuildContext context, String text) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget ?child) {
          return Theme(
            data: ThemeData(
              splashColor: Colors.black,
              textTheme: const TextTheme(
                titleSmall: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
              ),
              dialogBackgroundColor: Colors.white, colorScheme: const ColorScheme.light(
                primary: Color(0xff1565C0),
                primaryContainer: Colors.black,
                secondaryContainer: Colors.black,
                onSecondary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.black,
                onSurface: Colors.black,
                secondary: Colors.black).copyWith(primaryContainer: Colors.grey, secondary: Colors.black),
            ),
            child: child ??const Text(""),
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2024));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        if(text == "From Date"){
          datefrom = picked;
          indianFromDate =  DateFormat("dd.MM.yyyy").format(picked);
          print("indianDate===> ${indianFromDate}");
        }else if(text == "To Date"){
          dateto = picked;
          indianToDate =  DateFormat("dd.MM.yyyy").format(picked);
          print("indianDate===> ${indianToDate}");
        }

      });
    }
  }

  Future<void> createTask( String value) async {
    var jsonData = null;

    dynamic response = await HTTP.get(createTaskAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      TaskRespons taskRespons = TaskRespons.fromJson(jsonData);
      if(taskRespons.dataSuccess[2].syncData == "EMP_TASK" && taskRespons.dataSuccess[2].value == "Y"){
        Utility().showToast("Task has been assigned.");
        Navigator.of(context).pop();
      }else {
          Utility().showToast("Something went wrong try again.");
        }

    }
  }

}