import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/sidemenu/attendanceCorrection/model/attcorrectionresponse.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import '../../webservice/constant.dart';

class AttendenceCorrectionScreen extends StatefulWidget {
  const AttendenceCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<AttendenceCorrectionScreen> createState() => _AttendenceCorrectionScreenState();
}

class _AttendenceCorrectionScreenState extends State<AttendenceCorrectionScreen> {

  DateTime datefrom = DateTime.now();
  String?  selectedFromDate, selectedToDate,attendenceTypeSpinner;
  TextEditingController targetDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController remark = TextEditingController();
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;  bool isLoading = false;

  var attendenceTypeList = [
    'Present',
    'First Half Present',
    'Second Half Present',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

      targetDateController.text =
          DateFormat(dateTimeFormat).format(DateTime.now());

      selectedFromDate = DateFormat("yyyyMMdd").format(DateTime.now());
      selectedToDate = DateFormat("yyyyMMdd").format(DateTime.now());
      fromDateController.text =
          DateFormat(dateTimeFormat).format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title:   robotoTextWidget(
            textval: attendanceC,
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
      body:Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(height: 20,),

                  datePickerWidget(fromDateController.text, fromDateController, "0"),
                  attendenceTypeSpinnerWidget(),
                  remarkWidget(),
                  submitWidget(),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  datePickerWidget(
      String fromTO, TextEditingController DateController, String value) {
    return GestureDetector(
      onTap: () {
        _selectDate(context, value);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1,
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
                ),)
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String value) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate:  DateTime.now().subtract(new Duration(days: 3)),
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
          selectedFromDate = DateFormat("yyyyMMdd").format(pickedDate!);
        }
      });
    }
  }

  attendenceTypeSpinnerWidget() {
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
              hintText: selectattendence,
              fillColor: Colors.white),
          value: attendenceTypeSpinner ,
          validator: (value) =>
          value == null || value.isEmpty ? selectattendence : "",
          items: attendenceTypeList
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
              attendenceTypeSpinner = value.toString();
            });
          },
        ),);
  }

  remarkWidget() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: remark,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.edit_note,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: remarktxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
        ),
        keyboardType: TextInputType.text,
        maxLines: 2,
      ),
    );
  }

  submitWidget( ) {
    return GestureDetector(
        onTap: () {
           validation();
        },
        child: Container(
          height: 46,
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width / 1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child:    isLoading !=true? robotoTextWidget(
                textval: submit,
                colorval: Colors.white,
                sizeval: 14,
                fontWeight: FontWeight.bold):CircularProgressIndicator(color: Colors.white,),
          ),
        ));
  }

  void validation() {
      if (fromDateController.text.toString().isEmpty) {
          Utility().showToast(selectFromDate);
    }else if(attendenceTypeSpinner!.isEmpty){
        Utility().showToast(selectattendence);
      }else if(remark.text.toString().isEmpty){
        Utility().showInSnackBar(value: vaildRemark, context: context);
      }else{
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
            applyAttendenceCorrection();
          } else {
            Utility()
                .showInSnackBar(value: checkInternetConnection, context: context);
          }
        });
      }
  }

  Future<void> applyAttendenceCorrection()  async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dynamic response = await HTTP.get(createAttendenceCorrectionAPI(
        sharedPreferences.getString(userID).toString(),
        selectedFromDate!,
        attendenceTypeSpinner.toString(),
        remark.text.toString(),
        ));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      AttendenceCorrResponse attendenceCorrResponse = AttendenceCorrResponse.fromJson(jsonData);

      print('attendenceCorrResponse  ${attendenceCorrResponse.toString()}');

      if (attendenceCorrResponse.status.compareTo("False") != 0) {
        Utility().showToast(attendenceCorrResponse.message);
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        Utility().showToast(attendenceCorrResponse.message);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Utility().showToast(somethingWentWrong);
    }
  }
}
