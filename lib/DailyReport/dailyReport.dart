import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import 'package:shakti_employee_app/home/home_page.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import '../uiwidget/robotoTextWidget.dart';
import 'model/vendornamelistresponse.dart' as VenderList;
import 'model/vendornamelistresponse.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  String? _selectedType;

  String TypeSpinner = 'Select Visit At ';

  var TypeList = [
    'Select Visit At ',
    'Supplier Premises',
    'Shakti H.O',
  ];

  String statusType = "Select Status";

  var statusList = [
    'Select Status',
    'Open',
    'Close',
    'In Progress',
  ];

  List<VenderList.Response> vendorNameList = [];
  TextEditingController vendoreName = TextEditingController();
  TextEditingController vendoreCode = TextEditingController();
  TextEditingController vendoreAddress = TextEditingController();
  TextEditingController vendoreContac = TextEditingController();
  TextEditingController person1 = TextEditingController();
  TextEditingController person2 = TextEditingController();
  TextEditingController person3 = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController agenda = TextEditingController();
  TextEditingController discussion = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime datefrom = DateTime.now();
  String? indianFromDate, selectedFromDate;
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedFromDate = DateFormat(dateTimeFormat).format(DateTime.now());
    fromDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());
    indianFromDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: const robotoTextWidget(
            textval: "Daily Report",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            radtiobuttonWidget(),
            textVendorFeildWidget(
              "Vendor Name",
            ),
            textFeildWidget("Vendor Code", vendoreCode),
            textFeildWidget("Vendor Address", vendoreAddress),
            textFeildWidget("Vendor Contact N0", vendoreContac),
            dateTextFeildWidget("Current Date",
                DateFormat("dd-MM-yyyy").format(DateTime.now())),
            TypeSpinnerWidget(),
            textFeildWidget("Responsible person", person1),
            textFeildWidget("Responsible person 2", person2),
            textFeildWidget("Responsible person 3", person3),
            longTextFeildWidget("Agenda", agenda),
            longTextFeildWidget("Discussion", discussion),
            statusSpinnerWidget(),
            datePickerWidget(selectedFromDate!, fromDateController, "0"),
          ],
        ),
      ),
    );
  }

  textFeildWidget(String hinttxt, TextEditingController visitPlace) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hinttxt,
              style: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: const EdgeInsets.only(left: 15),
          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: visitPlace,
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Please Enter " + hinttxt,
              hintStyle: const TextStyle(
                  color: AppColor.themeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  radtiobuttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Row(
              children: <Widget>[
                Radio(
                  value: "Vendor",
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Text(
                  'Vendor',
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Row(
              children: <Widget>[
                Radio(
                  value: "Prospective Vendor",
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Flexible(
                    child: Text(
                  'Prospective Vendor',
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TypeSpinnerWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(
            height: 0,
          ),
          value: TypeSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: TypeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(
                  child: robotoTextWidget(
                      textval: items,
                      colorval: AppColor.themeColor,
                      sizeval: 13,
                      fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              TypeSpinner = newValue!;
            });
          },
        ),
      ),
    );
  }

  dateTextFeildWidget(String s, String date) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            s,
            style: const TextStyle(
                color: Colors.black45, fontWeight: FontWeight.bold),
          )),
      Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.themeColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: TextField(
          style: const TextStyle(color: AppColor.themeColor),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: date,
            hintStyle: const TextStyle(
                color: AppColor.themeColor,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          keyboardType: TextInputType.text,
        ),
      )
    ]);
  }

  longTextFeildWidget(String s, TextEditingController longtext) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              s,
              style: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: const EdgeInsets.only(left: 15),
          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            maxLines: 3,
            controller: longtext,
            style: const TextStyle(color: AppColor.themeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Please Enter " + s,
              hintStyle: const TextStyle(
                  color: AppColor.themeColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 13),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  statusSpinnerWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(
            height: 0,
          ),
          value: statusType,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: statusList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(
                  child: robotoTextWidget(
                      textval: items,
                      colorval: AppColor.themeColor,
                      sizeval: 13,
                      fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              statusType = newValue!;
            });
          },
        ),
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
                  fontWeight: FontWeight.bold),
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
            : selectedFromDate !=
                    DateFormat(dateTimeFormat).format(DateTime.now())
                ? DateTime(2023)
                : DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      String formattedDate = DateFormat(dateTimeFormat).format(pickedDate!);
      setState(() {
        if (value == "0") {
          selectedFromDate = DateFormat(dateTimeFormat).format(pickedDate!);
          fromDateController.text = formattedDate;
        }
      });
    }
  }

  Future<void> vendorNameListAPI(String value) async {
    var jsonData = null;
    dynamic response = await HTTP.get(vendorNameAPI(value));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      VendorNameResponse vendorNameResponse =
          VendorNameResponse.fromJson(jsonData);
      if (vendorNameResponse.status == "true" &&
          vendorNameResponse.response.isNotEmpty)
        setState(() {
          vendorNameList = vendorNameResponse.response;
        });
    }
  }

  textVendorFeildWidget(String hinttxt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hinttxt,
              style: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.bold),
            )),
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SearchField<List<VenderList.Response>>(
            suggestions: vendorNameList
                .map(
                  (vendornamelist) =>
                      SearchFieldListItem<List<VenderList.Response>>(
                    vendornamelist.name1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        vendornamelist.name1,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: AppColor.themeColor),
                      ),
                    ),
                  ),
                )
                .toList(),
            searchInputDecoration: InputDecoration(
              hintText: "Search by " + hinttxt,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColor.themeColor,
              ),
              border: InputBorder.none,
            ),
            onSearchTextChanged: (serachValue) {
              if (serachValue.length > 2) {
                vendorNameListAPI(serachValue);
              }
              return null;
            },
            onSubmit: (String value) {
              setState(() {
                vendoreContac.text = vendorNameList[0].telf1;
              });
            },
          ),
        )
      ],
    );
  }
}
