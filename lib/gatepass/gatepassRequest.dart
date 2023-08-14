import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/gatepass/model/gatePassResponse.dart';
import 'package:shakti_employee_app/home/home_page.dart';
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


  String ?  selectedAssginTo;
  TimeOfDay? fromTime = TimeOfDay.now(), comeBackTime = TimeOfDay.now();

  String returnableSpinner = 'Returnable',dateTimeFormat ="dd/MM/yyyy", timeFormate = "hh:mm";
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

  String?   _hour, _minute,_time, _comeTime;
  String?    dayTypeSpinner, returnalbeTypeSpinner,selectedFromDate, selectedToDate;
  bool isListVisible = false;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  DateTime? pickedDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      selectedFromDate = DateFormat(dateTimeFormat).format(DateTime.now());
      selectedToDate = DateFormat(dateTimeFormat).format(DateTime.now());
      fromDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());
      toDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());
      _time = formatDate(
          DateTime(2019, 08, 1, DateTime.now()!.hour, DateTime.now()!.minute),
          [hh, ':', nn, " ", am]).toString();

      fromTimeController.text = _time!;
      toTimeController.text = _time!;
    });

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
            icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  datePickerWidget(
                      selectedFromDate!, fromDateController, "0"),
                  datePickerWidget(
                      selectedToDate!, toDateController, "1")
                ],
              ),
              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  timePickerWidget(
                      selectedFromDate!, fromTimeController, "0"),
                  timePickerWidget(
                      selectedToDate!, toTimeController, "1")
                ],
              ),
              const SizedBox(height: 10,),
              leaveTypeSpinnerWidget(),
              const SizedBox(
                height: 10,
              ),
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
      margin: const EdgeInsets.only(top: 10, bottom: 10),
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
          hintStyle: TextStyle(color: AppColor.themeColor, fontSize: 12, fontWeight: FontWeight.normal),
          prefixIcon: Icon(Icons.person,   size: 20, color: AppColor.themeColor,),
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


  textFieldWidget(String hinttxt, TextEditingController visitPlace) {
    return  Container(
      margin: const EdgeInsets.only( top: 10),
      padding:  const EdgeInsets.only( left: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      child:  TextField(
        controller: visitPlace,
        style: const TextStyle(color: AppColor.themeColor),
        decoration:  InputDecoration(

          border: InputBorder.none,
          hintText: hinttxt,
          hintStyle:
          const TextStyle(color: AppColor.themeColor,fontSize: 12),
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
                ? const SizedBox(
              height: 30,
              width: 30,
              child:
              CircularProgressIndicator(
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
    returnalbeTypeSpinner ??= "";
    dayTypeSpinner ??= "";

       if(dayTypeSpinner.toString().isEmpty){
      Utility().showToast("Please enter gate pass type");
    }
    else  if(returnalbeTypeSpinner.toString().isEmpty){
      Utility().showToast("Please enter returnable type");
    }
    else  if(purpose.text.toString().isEmpty){
      Utility().showToast("Please enter purpose");
    } else if(visitPlace.text.toString().isEmpty ) {
         Utility().showToast("Please enter visit place ");
       }
    else {
      gatePassRequestAPI();
    }
  }

  leaveTypeSpinnerWidget() {
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
              hintText: 'Select return type',
              fillColor: Colors.white),
          value: returnalbeTypeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? 'Select return type' : "",
          items: returnableList
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
              returnalbeTypeSpinner = value.toString();
            });
          },
        ));
  }

  dayTypeSpinnerWidget() {
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
              hintText: 'Select Gate Pass type',
              fillColor: Colors.white),
          value: dayTypeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? 'Select Gate Pass type' : "",
          items: TypeList
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

  timePickerWidget(  String fromTO, TextEditingController timeController, String value)  {
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

  void _selectTime(String value) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: fromTime!,
    );
    if (newTime != null) {
      setState(() {
        if (value == "0") {

          _time = formatDate(
              DateTime(2019, 08, 1, newTime!.hour, newTime!.minute),
              [hh, ':', nn, " ", am]).toString();

          fromTimeController.text = _time!;

        } else  if (value == "1") {
          _time = formatDate(
              DateTime(2019, 08, 1, newTime!.hour, newTime!.minute),
              [hh, ':', nn, " ", am]).toString();

          toTimeController.text = _time!;
        }
      });

    }
  }

  Future<void> gatePassRequestAPI() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? sapcode = sharedPreferences.getString(userID).toString()  ;

    dynamic response = await HTTP.get(createGatePassAPI(sapcode,fromDateController.text.toString(),_time.toString(),dayTypeSpinner.toString(),returnalbeTypeSpinner.toString(),toDateController.text.toString(),_comeTime.toString(),visitPlace.text.toString(),purpose.text.toString(),selectedAssginTo.toString()));
    if (response != null && response.statusCode == 200)  {
      Iterable l = convert.json.decode(response.body);
      List<GatePassResponse> odResponse = List<GatePassResponse>.from(l.map((model)=> GatePassResponse.fromJson(model)));

      if(odResponse[0].msgtyp.compareTo("S") == 0){

        Utility().showToast(odResponse[0].text);

        Navigator.of(context).pop();

      }
      else{
        Utility().showToast(odResponse[0].text);
      }
  }else{
      Utility().showToast(somethingWentWrong);
    }
  }
}