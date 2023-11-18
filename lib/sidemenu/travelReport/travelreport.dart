import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/sidemenu/travelReport/model/travellistrequest.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import 'dart:convert' as convert;

class TravelReportScreen extends StatefulWidget {
  const TravelReportScreen({Key? key}) : super(key: key);

  @override
  State<TravelReportScreen> createState() => _TravelReportScreenState();
}

class _TravelReportScreenState extends State<TravelReportScreen> {

  List<Response> travelListResponse = [];
  List<Response> displayList = [];
  bool listView = false, isLoading = false,pdfLoading = false;
  DateTime datefrom = DateTime.now();
  String?  selectedFromDate, selectedToDate;
  TextEditingController targetDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;

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
            textval: travelReport,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      datePickerWidget(fromDateController.text, fromDateController, "0"),
                      datePickerWidget(toDateController.text, toDateController, "1")
                    ],
                  ),
                  submitWidget(submit),

                  _buildPosts(context)
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


  submitWidget(String title) {
    return GestureDetector(
        onTap: () {
          validation(title);
        },
        child: Container(
          height: 46,
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width / 1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: robotoTextWidget(
                textval: title,
                colorval: Colors.white,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget _buildPosts(BuildContext context) {
    if(travelListResponse.isEmpty && listView){
      return NoDataFound();
    }else if(travelListResponse.isEmpty && !listView){
      return Container();
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
        ),

        travelListResponse.length > 0
            ? ListView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListItem(index);
          },
          itemCount: displayList.length,
          padding: const EdgeInsets.all(2),
        )
            : NoDataFound()
      ],
    );
  }

  SizedBox NoDataFound() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(30, 136, 229, .2),
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ]),
            child: Align(
              alignment: Alignment.center,
              child: robotoTextWidget(
                textval: noDataFound,
                colorval: AppColor.themeColor,
                sizeval: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }

  Wrap ListItem(int index) {
    return Wrap(children: [
      Card(
          elevation: 10,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.greyBorder,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            width: 400,
            color: AppColor.whiteColor,
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailWidget(docNo, displayList[index].docno ),
                    detailWidget(createDate, displayList[index].createdDate),
                    detailWidget(from,displayList[index].travelFrom ),
                    detailWidget(to, displayList[index].travelTo  ),
                    detailWidget(dateFrom, displayList[index].travelDateFrom ),
                    detailWidget(dateTo, displayList[index].travelDateTo ),
                    detailWidget(status, setValue(displayList[index].status) ),
                    detailWidget(travelMode, setBookingValue(displayList[index].bookingType) ),
                    detailWidget(remarktxt, displayList[index].suggested ),
                    detailWidget(mobile, displayList[index].mob),
                  ],
                ),
              ],
            ),
          )),
    ]);
  }

  void validation(String title) {

    print("Date====>${selectedFromDate}==== ${selectedToDate}");

      Utility().checkInternetConnection().then((connectionResult) async {
        if (connectionResult) {
          getTravelListResponse();
        } else {
          Utility()
              .showInSnackBar(value: checkInternetConnection, context: context);
        }
      });


  }

  Future<void> getTravelListResponse() async {
    setState(() {
      isLoading = true;
    });
    var jsonData = null;
    travelListResponse =[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dynamic response = await HTTP.get(getTravelListResponseAPI(sharedPreferences.getString(userID).toString(),selectedFromDate.toString(),selectedToDate.toString() ));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      TravelListResponse travelListResponseResponse =
      TravelListResponse.fromJson(jsonData);
      travelListResponse = travelListResponseResponse.response;

      displayList = travelListResponse;
      setState(() {
        listView =true;
        isLoading = false;
      });
    } else {
      Utility().showInSnackBar(value: somethingWentWrong, context: context);
      setState(() {
        isLoading = false;
      });
    }
  }

  detailWidget(String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.25,
      padding: EdgeInsets.only(left: 10,),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          robotoTextWidget(
            textval: title,
            colorval: AppColor.blackColor,
            sizeval: 14.0,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: robotoTextWidget(
              textval: value,
              colorval: AppColor.themeColor,
              sizeval: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Response> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = travelListResponse;
    } else {
      results = travelListResponse.where((list) =>
      list.status.contains(enteredKeyword )|| list.docno.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      displayList = results;
    });

  }

  String setValue(String value) {
    if(value.compareTo("A") == 0){
      return "Approved";
    }
   else if(value.compareTo("R") == 0){
      return "Reject";
    } else if(value.compareTo("P") == 0){
      return "Pending";
    }
    return "";
  }

  String setBookingValue(String bookingType) {
    if(bookingType.compareTo("A") == 0){
      return "Bus";
    }
    else if(bookingType.compareTo("B") == 0){
      return "Flight";
    } else if(bookingType.compareTo("C") == 0){
      return "Train";
    }else if(bookingType.compareTo("D") == 0){
      return "Taxi";
    }else if(bookingType.compareTo("E") == 0){
      return "Hotel";
    }
    return "";

  }
}
