import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/officialDuty/model/odResponse.dart';
import 'dart:convert' as convert;
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:searchfield/searchfield.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_page.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/constant.dart';

class OfficialRequest extends StatefulWidget {

  List<Activeemployee> activeemployeeList = [];
   OfficialRequest({Key? key ,  required this.activeemployeeList}) : super(key: key);

  @override
  State<OfficialRequest> createState() => _OfficialRequestState();
}

class _OfficialRequestState extends State<OfficialRequest>  {

  bool isLoading = false;
  TextEditingController reason = TextEditingController();
  TextEditingController visitPlaceController = TextEditingController();
  TextEditingController purpose1 = TextEditingController();
  TextEditingController purpose2 = TextEditingController();
  DateTime? pickedDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  String?  selectedAssginTo;
  String?  dutyTypeSpinner, workPlaceSpinner,selectedFromDate, selectedToDate;

  String  dateFormat ="dd/MM/yyyy",timeFormat = "HH:mm:ss";

  var dutyTypeList = [
    'On Duty',
    'On Tour',
  ];

  String workPlace = "Select Work Place";

  var workplaceList = [
    "Select Work Place",
    "State Bank of India-01",
    "State Bank of Indore-02",
    "Other Bank-03",
    "Income Tax Office-04",
    "Central Excise Office-05",
    "Sales Tax Office-06",
    "High Court-07",
    "District Court-08",
    "Labour Court-09",
    "ICD-10",
    "Indore Godown-11",
    "Nagar Nigam-12",
    "Pollution Control Board-13",
    "MPAKVN Indore-14",
    "SPIL Industries-15",
    "SEZ Plant-16",
    "SEZ Office-17",
    "MPFC-18",
    "Exhibition-19",
    "Seminar-20",
    "Others-21",
    "Sales Office-22",
    "Business Tour-23",
    "Training-24",
    "Vendor visit-25",
    "Vendor Mtl. inspection & Dispatch-26"
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedFromDate = DateFormat(dateFormat).format(DateTime.now());
      selectedToDate = DateFormat(dateFormat).format(DateTime.now());
      fromDateController.text = DateFormat(dateFormat).format(DateTime.now());
      toDateController.text = DateFormat(dateFormat).format(DateTime.now());

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
            textval: officialRequest,
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
        padding: const EdgeInsets.only(top: 20,left: 10, right: 10),
        height: double.infinity,
        width: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            children: [
              dutyTypeSpinnerWidget(),
                const SizedBox(height: 10,),
              WorkPlaceSpinnerWidget(),
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  timePickerWidget(
                      selectFromTime, fromTimeController, "0"),
                  timePickerWidget(selectToTime,toTimeController, "1")
                ],
              ),
              textFeildWidget(visitPlace, visitPlaceController),
              textFeildWidget( purpose1txt, purpose1),
              textFeildWidget(purpose2txt, purpose2),
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
        searchInputDecoration:   InputDecoration(
          hintText: assginCharge,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12, fontWeight: FontWeight.normal),
          prefixIcon: const Icon(Icons.person,   size: 20, color: AppColor.themeColor,),
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

  dutyTypeSpinnerWidget() {
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
              hintText: selectODType,
              fillColor: Colors.white),
          value: dutyTypeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectODType : "",
          items: dutyTypeList
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
              dutyTypeSpinner = value.toString();
            });
          },
        ));
  }

  WorkPlaceSpinnerWidget()  {
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
              hintText: selectWorkPlace,
              fillColor: Colors.white),
          value: workPlaceSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectWorkPlace : "",
          items: workplaceList
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
              workPlaceSpinner = value.toString();
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
                      hintStyle: const TextStyle(color: AppColor.themeColor,),
                      border: InputBorder.none),
                  style: const TextStyle(fontSize: 12, fontFamily: 'Roboto',fontWeight: FontWeight.bold,color: AppColor.themeColor),
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
        firstDate: DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate:  DateTime(2050));
    if (pickedDate != null) {
      String formattedDate = DateFormat(dateFormat).format(pickedDate!);
      setState(() {
        if (value == "0") {
          selectedFromDate = DateFormat(dateFormat).format(pickedDate!);
          fromDateController.text = formattedDate;
        } else {
          selectedToDate = DateFormat(dateFormat).format(pickedDate!);
          toDateController.text = formattedDate;
        }
      });
    }
  }

  timePickerWidget(
      String fromTO, TextEditingController timeController, String value) {
    return GestureDetector(
      onTap: () {
        _selectTime(value);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width ,
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

  void _selectTime(String value) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        if (value == "0") {
          fromTimeController.text = DateFormat(timeFormat).format(DateTime(2019, 08, 1, newTime.hour, newTime.minute));
        } else if (value == "1") {

          if(dutyTypeSpinner == 'On Duty') {
            toTimeController.text = DateFormat(timeFormat).format(
                DateTime(2019, 08, 1, newTime.hour, newTime.minute));
          }else{
            toTimeController.text = '00:00:00';
          }

        }
      });
    }
  }

  textFeildWidget(String hinttxt, TextEditingController visitPlace) {
    return  Container(
      padding: const EdgeInsets.only(left: 15),
      margin: const EdgeInsets.only(top: 10),
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
          const TextStyle(color: AppColor.themeColor, fontSize: 12),
        ),
        keyboardType: TextInputType.text,

      ),
    );
  }


  void Validation() {
    dutyTypeSpinner ??= "";
    workPlaceSpinner ??= "";

    if(workPlaceSpinner!.isEmpty ) {
      Utility().showToast(validWorkPlace);
    }
    if (fromDateController.text.toString().isEmpty) {
      Utility().showToast(validDate);
    }  else if(dutyTypeSpinner!.isEmpty) {
        Utility().showToast(validateOd);
      }else if (toDateController.text.toString().isEmpty) {
      Utility().showToast(vaildLeave);
    }else if(workPlaceSpinner ==  selectWorkPlace) {
      Utility().showToast(vaildDepartment);
    }else  if(purpose1.text.toString().isEmpty){
      Utility().showToast(vaildPurpose);
    }else {
      if ( dutyTypeSpinner == 'On Duty') {
        if(fromTimeController.text.toString().isEmpty){
          Utility().showToast("Please select from time");
        }
        else if(toTimeController.text.toString().isEmpty){
          Utility().showToast("Please select to time");
        }else{
          createOD();
        }


      }else {
        if(fromTimeController.text.toString().isEmpty){
          Utility().showToast("Please select from time");
        }else {
          toTimeController.text = '00:00:00';
          createOD();
        }
    }
  }
  }

  Future<void> createOD() async {

    setState(() {
      isLoading =true;
    });

   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? sapcode = sharedPreferences.getString(userID).toString() ;

    dynamic response = await HTTP.get(createODAPI(sapcode,
        dutyTypeSpinner.toString(),
        fromDateController.text.toString(),
        toDateController.text.toString(),
        visitPlaceController.text.toString(),
        workPlaceSpinner.toString(),
        purpose1.text.toString(),
        purpose2.text.toString(),
        '',
        '',
        selectedAssginTo.toString(),
        fromTimeController.text.toString()));
    if (response != null && response.statusCode == 200){

      Iterable l = convert.jsonDecode(response.body);
      List<OdResponse> odResponse =
      List<OdResponse>.from(
          l.map((model) => OdResponse.fromJson(model)));

      if(odResponse[0].name.compareTo("SAPLSPO1") == 0){
        Utility().showToast(odCreatedSuccess);

        Navigator.of(context).pop();
        setState(() {
          isLoading =false;
        });

      }else{
        Utility().showToast(odResponse[0].name);
        setState(() {
          isLoading =false;
        });
      }
    }else{
      Utility().showToast(somethingWentWrong);
    }
  }



}
