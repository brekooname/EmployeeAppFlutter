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
  TextEditingController visitPlace = TextEditingController();
  TextEditingController purpose1 = TextEditingController();
  TextEditingController purpose2 = TextEditingController();
  TextEditingController purpose3 = TextEditingController();
  TextEditingController purpose4 = TextEditingController();
  TextEditingController remark = TextEditingController();
  DateTime? pickedDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String?  selectedAssginTo;
  String?  dutyTypeSpinner, workPlaceSpinner,selectedFromDate, selectedToDate;

  String  dateTimeFormat ="dd/MM/yyyy";

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
    "Traning-24",
    "Vendor visit-25",
    "Vendor Mtl. inspection & Dispatch-26"
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
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
              textFeildWidget( "Visit Place", visitPlace),
              textFeildWidget( "Purpose 1", purpose1),
              textFeildWidget("Purpose 2", purpose2),
              textFeildWidget( "Purpose 3", purpose3),
              textFeildWidget( "Purpose 4", purpose4),
              textFeildWidget("Remark", remark),
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
              hintText: 'Select OD Type',
              fillColor: Colors.white),
          value: dutyTypeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please Select OD Type' : "",
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
              hintText: 'Select Work Place',
              fillColor: Colors.white),
          value: workPlaceSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please Select Work Place' : "",
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
      String formattedDate = DateFormat(dateTimeFormat).format(pickedDate!);
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
      Utility().showToast("Please select Work Place");
    }
    if (fromDateController.text.toString().isEmpty) {
      Utility().showToast("Please select leave from date");
    }  else if(dutyTypeSpinner!.isEmpty) {
        Utility().showToast("Please select OD type");
      }else if (toDateController.text.toString().isEmpty) {
      Utility().showToast("Please select leave to date");
    }else if(workPlaceSpinner ==  "Select Work Place") {
      Utility().showToast("Please select Department");
    }else  if(purpose1.text.toString().isEmpty){
      Utility().showToast("Please enter Purpose");
    } else  if(remark.text.toString().isEmpty){
      Utility().showToast("Please enter Remark");
    } else {
      createOD();
    }
  }

  Future<void> createOD() async {

   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? sapcode = sharedPreferences.getString(userID).toString() ;

    dynamic response = await HTTP.get(createODAPI(sapcode!,dutyTypeSpinner.toString(),fromDateController.text.toString(),toDateController.text.toString(),visitPlace.text.toString(),workPlaceSpinner.toString(),purpose1.text.toString(),purpose2.text.toString(),purpose3.text.toString(),remark.text.toString(),selectedAssginTo.toString()));
    if (response != null && response.statusCode == 200){
      var jsonData = convert.jsonDecode(response.body);
      OdResponse odResponse = OdResponse.fromJson(jsonData);

      if(odResponse.name.compareTo("SAPLSPO1") == 0){
        Utility().showToast("OD Created Successfully");

        Navigator.of(context).pop();

      }else{
        Utility().showToast(odResponse.name);
      }
    }
  }



}
