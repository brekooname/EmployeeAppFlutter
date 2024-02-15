import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/shiftCorrection/model/shiftrequestmodel.dart';
import 'package:shakti_employee_app/shiftCorrection/model/shiftsaveresposne.dart';
import 'package:shakti_employee_app/shiftCorrection/model/shifttypelistresponse.dart' as ShiftType;
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import '../webservice/constant.dart';


class ShiftCorrectionScreen extends StatefulWidget {
    ShiftCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<ShiftCorrectionScreen> createState() => _ShiftCorrectionScreenState();
}

class _ShiftCorrectionScreenState extends State<ShiftCorrectionScreen> {
  DateTime datefrom = DateTime.now();
  int selectedPosition = 0;
  String?  selectedFromDate, selectedToDate,shiftTypeSpinner,startTime, endTime;
  List<ShiftType.Response> shiftTypeList =[];
  TextEditingController targetDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController remark = TextEditingController();
  String dateTimeFormat = "dd/MM/yyyy",sendDateFormate = "yyyyMMdd";
  DateTime? pickedDate;  bool isLoading = false, isSend = false;
  List<ShiftRequestModel> shiftRequestList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

      targetDateController.text =
          DateFormat(sendDateFormate).format(DateTime.now());

      selectedFromDate = DateFormat("yyyyMMdd").format(DateTime.now());
      selectedToDate = DateFormat("yyyyMMdd").format(DateTime.now());
      fromDateController.text =
          DateFormat(dateTimeFormat).format(DateTime.now());

    });

    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        shiftListAPI();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
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
            textval: shiftC,
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
                  shiftTypeSpinnerWidget(),
                  remarkWidget(),
                  submitWidget(),
                ],
              ),
            ),
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : SizedBox(),
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
          targetDateController.text = DateFormat(sendDateFormate).format(pickedDate!);
        }
      });
    }
  }

  shiftTypeSpinnerWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
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
              hintText: selectShiftType,
              fillColor: Colors.white),
          value: shiftTypeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectShiftType : "",
          items: shiftTypeList.map((listItem) => DropdownMenuItem(
              value: listItem.shift,
              child: robotoTextWidget(
                  textval: listItem.shift  +" "+listItem.startTim + " to "+ listItem.endTim,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold))).toList(),

          onChanged: (Object? value) {
            setState(() {
              shiftTypeSpinner = value.toString();

              for (int i = 0; i < shiftTypeList.length; i++) {
                if (shiftTypeList[i].shift == value) {
                  selectedPosition = i;
                  break;
                }
              }
            });
          },
        ));
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
            child:    isSend !=true? robotoTextWidget(
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
    }else if(shiftTypeSpinner==null || shiftTypeSpinner!.isEmpty){
      shiftTypeSpinner = null;
      Utility().showInSnackBar(value: selectShift, context: context);
    }else if(remark.text.toString().isEmpty){
      Utility().showInSnackBar(value: vaildRemark, context: context);
    }else{
      Utility().checkInternetConnection().then((connectionResult) {
        if (connectionResult) {
          sendRequest();
        } else {
          Utility()
              .showInSnackBar(value: checkInternetConnection, context: context);
        }
      });
    }
  }

  void shiftListAPI() async {

    setState(() {
      isLoading = true;
    });
    var jsonData = null;

    dynamic response = await HTTP.get(getShiftTypeList());
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      ShiftType.ShiftTypeListResponse shiftTypeListResponse =
      ShiftType.ShiftTypeListResponse.fromJson(jsonData);

      if (shiftTypeListResponse.status == "true") {
        shiftTypeList = shiftTypeListResponse.response;

        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast(shiftTypeListResponse.message);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> sendRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    shiftRequestList.clear();
    shiftRequestList.add(ShiftRequestModel(
        pernr: sharedPreferences.getString(userID).toString(),
        begda: targetDateController.text.toString(),
        shift: shiftTypeSpinner!,
        shftInnTime: Utility.convertDateFormat(shiftTypeList[selectedPosition].startTim, "hh:mm:ss", "hhmmss"),
        shftOutTime:Utility.convertDateFormat(shiftTypeList[selectedPosition].endTim, "hh:mm:ss", "hhmmss"),
        remarkEmp: remark.text.toString()));
    String value = convert.jsonEncode(shiftRequestList).toString();
    print("Parameter Value===>${value.toString()}");
    
    sendShiftDataToSap(value);
  }

  void sendShiftDataToSap(String value)  async {

    setState(() {
      isSend = true;
    });
    var jsonData = null;

    dynamic response = await HTTP.get(sendShiftData(value));

    print("response====>${response.toString()}");
    print("statusCode====>${response.statusCode}");
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      ShiftResponseModel shiftResponseModel =
      ShiftResponseModel.fromJson(jsonData);

      print("shiftResponseModel====>${shiftResponseModel.toString()}");
      print("shiftResponseModel====>${shiftResponseModel.status}");
      if (shiftResponseModel.status == "true") {
        Utility().showToast(shiftResponseModel.message);
        Navigator.pop(context);
        setState(() {
          isSend = false;
        });
      } else {
        Utility().showToast(shiftResponseModel.message);
        setState(() {
          isSend = false;
        });
      }
    }
  }

}
