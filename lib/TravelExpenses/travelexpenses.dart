import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/TravelExpenses/addExpenses.dart';
import 'package:shakti_employee_app/TravelExpenses/model/trvaelExp.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/database/database_helper.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:shakti_employee_app/travelrequest/model/countrylistrequest.dart' as C;
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

class TravelExpensesScreen extends StatefulWidget {
  const TravelExpensesScreen({Key? key}) : super(key: key);

  @override
  State<TravelExpensesScreen> createState() => _TravelExpensesScreenState();
}

class _TravelExpensesScreenState extends State<TravelExpensesScreen> {

  bool listView = false, isLoading = false,pdfLoading = false;
  DateTime datefrom = DateTime.now();
  String?  selectedFromDate, selectedToDate;
  TextEditingController targetDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;
  List<C.Response> countryList = [];
  String? countryCodeSpinner = "IN";

  TravelExpenseModel? travelExpenseModel;
  List<TravelExpenseModel> savedtravelExpense = [];

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
      toDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());

    });

    getCountryList();
    getAllTraveExpenses();
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
            textval: travelEx,
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
      floatingActionButton:  FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddExpensesScreen()));
        },
        child: const Icon(Icons.add , color: AppColor.whiteColor,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      datePickerWidget(fromDateController.text, fromDateController, "0"),
                      datePickerWidget(toDateController.text, toDateController, "1")
                    ],
                  ),
                  countryListWidget(),
                  LocationofTravel(),
                  costCenterListWidget(),
                ],
              ),
            ),
          ),
          Center(
            child: isLoading == true
                ? const CircularProgressIndicator(
              color: Colors.indigo,
            )
                : const SizedBox(),
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

  Future<void> _selectDate(BuildContext context, String value) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate:  DateTime(1050),
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
        } else {
          selectedToDate = DateFormat(dateTimeFormat).format(pickedDate!);
          toDateController.text = formattedDate;
          selectedToDate = DateFormat("yyyyMMdd").format(pickedDate!);
        }
      });
    }
  }

  countryListWidget() {
    return  Container(
      margin: const EdgeInsets.only(top: 10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.themeColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
            hintText: selectCountryCode,
            fillColor: Colors.white),
        value:  countryCodeSpinner ,
        validator: (value) =>
        value == null || value.isEmpty ? selectCountryCode : "",
        items: countryList
            .map(( ListItem) => DropdownMenuItem(
            value: ListItem.land1,
            child: Container(

              child: robotoTextWidget(
                  textval: ListItem.landx50  +" " +ListItem.land1,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.bold),
              width: MediaQuery.of(context).size.width/2,     )))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            print('value=====>$value');
            countryCodeSpinner = value.toString();
          });
        },
      ),
    );
  }

  costCenterListWidget() {
    return  Container(
      margin: const EdgeInsets.only(top: 10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.themeColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
            hintText: selectCostCenter,
            fillColor: Colors.white),
        value:  countryCodeSpinner ,
        validator: (value) =>
        value == null || value.isEmpty ? selectCostCenter : "",
        items: countryList
            .map(( ListItem) => DropdownMenuItem(
            value: ListItem.land1,
            child: Container(

              child: robotoTextWidget(
                  textval: ListItem.landx50  +" " +ListItem.land1,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.bold),
              width: MediaQuery.of(context).size.width/2,)))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            print('value=====>$value');

            countryCodeSpinner = value.toString();

          });
        },
      ),
    );
  }

  LocationofTravel() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: locationController,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.location_pin,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: locationtxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 14),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Future<void> getCountryList() async {
    setState(() {
      isLoading = true;
    });

    var jsonData = null;

    dynamic response = await HTTP.get(getCountryListAPI());
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      C.CountryListResponse countryListResponse =
      C.CountryListResponse.fromJson(jsonData);
      setState(() {
        countryList = countryListResponse.response;
        isLoading = false;
      });
    } else {
      Utility().showInSnackBar(value: somethingWentWrong, context: context);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>?> getAllTraveExpenses() async {

    List<Map<String, dynamic>> listMap =
    await DatabaseHelper.instance.queryAllTravelExpenseTable();
    setState(() {
      listMap.forEach(
              (map) => savedtravelExpense.add(TravelExpenseModel.fromMap(map)));
    });

     // DatabaseHelper.instance.deleteDSREntry();

    print('savedtravelExpense=========>${savedtravelExpense.toString()}');
  }
}
