import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/gatepass/model/gatePassResponse.dart';
import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'dart:convert' as convert;
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../webservice/constant.dart';


class GatepassRequestScreen extends StatefulWidget {
  List<Activeemployee> activeemployeeList = [];
   GatepassRequestScreen({Key? key, required this.activeemployeeList}) : super(key: key);

  @override
  State<GatepassRequestScreen> createState() => _GatepassRequestState();
}

class _GatepassRequestState extends State<GatepassRequestScreen> {

  bool isLoading = false;

  TextEditingController visitPlace = TextEditingController();
  TextEditingController purpose = TextEditingController();

  DateTime datefrom = DateTime.now(), dateto = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String ? indianFromDate,indianToDate ,selectedAssginTo;
  TimeOfDay? fromTime = TimeOfDay.now(), comeBackTime = TimeOfDay.now();

  String returnableSpinner = 'Returnable';
  // List of items in our dropdown menu
  var returnableList = [
    'Returnable',
    'Non-Returnable',
  ];

  String typeSpinner = 'Personal';

  // List of items in our dropdown menu
  var TypeList = [
    'Personal',
    'Official',
  ];

  String? _hour, _minute, _time, _comeTime;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    indianFromDate =  DateFormat("dd/MM/yyyy").format(DateTime.now());
    indianToDate =  DateFormat("dd/MM/yyyy").format(DateTime.now());

    _time = formatDate(
        DateTime(2019, 08, 1, fromTime!.hour, fromTime!.minute),
        [hh, ':', nn, " ", am]).toString();

    _comeTime = formatDate(
        DateTime(2019, 08, 1, comeBackTime!.hour, comeBackTime!.minute),
        [hh, ':', nn, " ", am]).toString();
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
            textval: gatepass,
            colorval: AppColor.whiteColor,
            sizeval: 15,
            fontWeight: FontWeight.w800),
        leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              datePickerWidget("Gatepass Date",indianFromDate.toString()),
              SizedBox(height: 10,),
              timePickerWidget("Gatepass Time",_time),
              SizedBox(height: 10,),
              datePickerWidget("Comeback Date",indianToDate.toString()),
              SizedBox(height: 10,),
              timePickerWidget("Comeback Time",_comeTime),
              leaveTypeSpinnerWidget(),
              dayTypeSpinnerWidget(),
              textFieldWidget("Place to Visit", visitPlace),
              textFieldWidget("Purpose", purpose),
              assginToSpinnerWidget(context,widget.activeemployeeList),
              submitWidget(),
            ],
          ),
        ),
      ),
    );
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

  textFieldWidget(String hinttxt, TextEditingController visitPlace) {
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
            Icons.star_border,
            color: AppColor.themeColor,
          ),
          border: InputBorder.none,
          hintText: hinttxt,
          hintStyle:
          const TextStyle(color: AppColor.themeColor),
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

  void Validation() {
    //Validation

    if(visitPlace.text.toString().isEmpty ) {
      Utility().showToast("Please enter person in charge");
    }
    else  if(purpose.text.toString().isEmpty){
      Utility().showToast("Please enter person in charge");
    }
    else {
      setState(() {
        print("personInChager1 ${visitPlace.text.toString()}");
        print("personInChager3 ${purpose.text.toString()}");
      });

      gatePassRequestAPI();
    }
  }

  leaveTypeSpinnerWidget() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: SizedBox(height: 0,),
          value: returnableSpinner,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: returnableList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.w400)),
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

  dayTypeSpinnerWidget() {
    return  Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: SizedBox(height: 0,),
          value: typeSpinner,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: TypeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.w400)),
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
        firstDate: DateTime.now(),
        lastDate: DateTime(2026));
    if (picked != null && picked != selectedDate) {
      setState(() {

        if(text == "Gatepass Date"){
          datefrom = picked;
          indianFromDate =  DateFormat("dd/MM/yyyy").format(picked);
        }else if(text == "Comeback Date"){
          dateto = picked;
          indianToDate =  DateFormat("dd/MM/yyyy").format(picked);

        }


      });
    }
  }

  timePickerWidget(String text, String? time)  {
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
              onPressed: () => _selectTime(text),
              child:  robotoTextWidget(textval: text, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15.0,),
            robotoTextWidget(textval: time.toString(), colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.normal)
          ],
        ),
      ),
    );
  }

  void _selectTime(String title) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: fromTime!,
    );
    if (newTime != null) {
      setState(() {

        if(title == "Gatepass Time"){

          fromTime = newTime;
          _hour = fromTime?.hour.toString();
          _minute = fromTime?.minute.toString();
          _time = _hour! + ' : ' + _minute!;

          _time = formatDate(
              DateTime(2019, 08, 1, fromTime!.hour, fromTime!.minute),
              [hh, ':', nn, " ", am]).toString();
        }else{
          comeBackTime = newTime;
          _hour = comeBackTime?.hour.toString();
          _minute = comeBackTime?.minute.toString();
          _comeTime = _hour! + ' : ' + _minute!;

          _comeTime = formatDate(
              DateTime(2019, 08, 1, comeBackTime!.hour, comeBackTime!.minute),
              [hh, ':', nn, " ", am]).toString();
        }

      });

      setState(() {

      });

      print("Current Time: ${_time}");
    }
  }

  Future<void> gatePassRequestAPI() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? sapcode = sharedPreferences.getString(userID).toString()  ;

    dynamic response = await HTTP.get(createGatePassAPI(sapcode,indianFromDate.toString(),_time.toString(),typeSpinner.toString(),returnableSpinner.toString(),indianToDate.toString(),_comeTime.toString(),visitPlace.text.toString(),purpose.text.toString(),selectedAssginTo.toString()));
    if (response != null && response.statusCode == 200)  {

      print("response======>${response.toString()}");
      Iterable l = convert.json.decode(response.body);
      List<GatePassResponse> odResponse = List<GatePassResponse>.from(l.map((model)=> GatePassResponse.fromJson(model)));
      print("response======>${odResponse[0].text}");

      if(odResponse[0].msgtyp.compareTo("S") == 0){

        Utility().showToast(odResponse[0].text);

        Navigator.of(context).pop();

      }
      else{
        Utility().showToast(odResponse[0].text);
      }
  }
  }
}