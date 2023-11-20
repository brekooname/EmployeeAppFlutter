import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/travelrequest/model/citylistresponse.dart'as City;
import 'package:shakti_employee_app/travelrequest/model/statelistresponse.dart' as S;
import 'package:shakti_employee_app/travelrequest/model/travelresponse.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../theme/color.dart';
import '../webservice/APIDirectory.dart';
import '../webservice/constant.dart';
import 'model/countrylistrequest.dart' as C;
import 'model/travelrequest.dart';

class TravelRequestScreen extends StatefulWidget {
    TravelRequestScreen({Key? key}) : super(key: key);

  @override
  State<TravelRequestScreen> createState() => _TravelRequestScreenState();
}

class _TravelRequestScreenState extends State<TravelRequestScreen> {

  bool isLoading = false,isHotel = false, isSend = false;
  List<C.Response> countryList = [];
  List<S.Response> stateList = [];
  List<S.Response> stateToList = [];
  List<City.Response> cityList = [];
  List<City.Response> cityToList = [];
  String? countryCodeSpinner = "IN", countryToCodeSpinner="IN",
      stateCodeSpinner, stateToCodeSpinner,cityCodeSpinner,
      cityToCodeSpinner, bookingTypeSpinner  , slotTimeSpinner ,
      sendTimeSlot, sendBookingType, fromCity,toCity;
  var bookingTypeList = [ "Bus", "Flight","Train","Taxi","Hotel"];
  var timeSlotList = ["Morning 6am - 12am", "Afternoon 12am - 4pm","Evening 4pm - 8pm","MidNight 8pm - 6am"];

  TextEditingController nameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController localController = TextEditingController();
  late SharedPreferences sharedPreferences;
  TravelRequest? travelRequest;
  List<String>  sendTravelRequest=[];

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
    targetDateController.text =
        DateFormat(dateTimeFormat).format(DateTime.now());

    selectedFromDate = DateFormat("yyyyMMdd").format(DateTime.now());
    selectedToDate = DateFormat("yyyyMMdd").format(DateTime.now());
    fromDateController.text =
        DateFormat(dateTimeFormat).format(DateTime.now());
    toDateController.text = DateFormat(dateTimeFormat).format(DateTime.now());

    setState(() {

    });

    getCountryList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: travel,
            colorval: AppColor.whiteColor,
            sizeval: 16,
            fontWeight: FontWeight.w600),
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
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  nameWidget(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      datePickerWidget(fromDateController.text, fromDateController, "0"),
                      datePickerWidget(toDateController.text, toDateController, "1")
                    ],
                  ),
                  timeSlotWidget(),
                  bookingTypeWidget(),
                  Visibility(child: localAddressWidget(),
                    visible: isHotel),
                  textWidget("From Detail"),
                  countryListWidget(),
                  stateListWidget(),
                  cityListWidget(),
                  Visibility(child:  textWidget("To Detail"),
                      visible: isHotel?false:true),
                  Visibility(child: countryToListWidget(),
                      visible: isHotel?false:true),
                  Visibility(child: stateToListWidget(),
                      visible: isHotel?false:true),
                  Visibility(child: cityToListWidget(),
                      visible: isHotel?false:true),

                  remarkWidget(),
                  submitWidget()
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

  nameWidget() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: nameController,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: govtxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
        ),
        keyboardType: TextInputType.text,
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

  remarkWidget() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10,bottom: 10),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: remarkController,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: remarktxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  countryListWidget( ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        height: 52,
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
              child: robotoTextWidget(
                  textval: ListItem.landx50  +" " +ListItem.land1,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');


                countryCodeSpinner = value.toString();
                stateCodeSpinner = null;


              Utility().checkInternetConnection().then((connectionResult) async {
                if (connectionResult) {
                   getStateList(0);
                } else {
                  Utility()
                      .showInSnackBar(value:  checkInternetConnection, context: context);
                }
              });
            });
          },
        ),
      ),
    );
  }

  stateListWidget( ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        height: 52,
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
              hintText: selectStateCode,
              fillColor: Colors.white),
          value: stateCodeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectStateCode : "",
          items: stateList
              .map(( ListItem) => DropdownMenuItem(
              value: ListItem.bland,
              child: robotoTextWidget(
                  textval: ListItem.bezei  +" " +ListItem.bland,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');


                stateCodeSpinner = value.toString();
                cityCodeSpinner = null;


              Utility().checkInternetConnection().then((connectionResult) async {
                if (connectionResult) {
                  getCityList(0);
                } else {
                  Utility()
                      .showInSnackBar(value:  checkInternetConnection, context: context);
                }
              });
            });
          },
        ),
      ),
    );
  }

  cityListWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10,bottom: 10),
      child: Container(
        height: 52,
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
              hintText: selectCityCode,
              fillColor: Colors.white),
          value: cityCodeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectCityCode : "",
          items: cityList
              .map(( ListItem) => DropdownMenuItem(
              value: ListItem.cityc,
              child: robotoTextWidget(
                  textval: ListItem.bezei  +" " +ListItem.cityc,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');
              cityCodeSpinner = value.toString();
              for(var i = 0 ; i<cityList.length ; i++){
                if(cityCodeSpinner == cityList[i].cityc){
                  fromCity =  cityList[i].bezei;
                }
              }
            });
          },
        ),
      ),
    );
  }

  bookingTypeWidget() {
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
              hintText: selectBookingTime,
              fillColor: Colors.white),
          value: bookingTypeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectBookingTime : "",
          items: bookingTypeList
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
              bookingTypeSpinner = value.toString();
              if(value == "Bus"){
                sendBookingType = 'A';
                isHotel =false;
              } else if(value == "Flight"){
                sendBookingType = 'B';
                print("object22  ${sendBookingType}");
                isHotel =false;
              }  else if(value == "Train"){
                sendBookingType = 'C';
                isHotel =false;
              }else if(value == "Taxi"){
                sendBookingType = 'D';
                isHotel =false;
              }else if(value == "Hotel"){
                sendBookingType = 'E';
                isHotel =true;
              }
            });

            print("object===>$bookingTypeSpinner");
          },
        ));
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
  getStateList(2);
  isLoading = false;
  });
  } else {
  Utility().showInSnackBar(value: somethingWentWrong, context: context);
  setState(() {
  isLoading = false;
  });
  }
}

  Future<void> getStateList(int pos ) async {
    setState(() {
      isLoading = true;
    });

    if(pos == 0){
      stateList = [];
    }else if (pos == 1){
      stateToList = [];
    }else {
      stateList = [];
      stateToList = [];
    }

    var jsonData = null;

    dynamic response = await HTTP.get(getStateListAPI(pos == 2 ?countryCodeSpinner!: pos == 1 ? countryToCodeSpinner! : pos==0?countryCodeSpinner!:countryToCodeSpinner!));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      S.StateListResponse stateListResponse =
      S.StateListResponse.fromJson(jsonData);

    //  print("object===> ${stateListResponse.toString()}");

      if(stateListResponse.status.compareTo("true") == 0){
        setState(() {

          if(pos == 0){
            stateList = stateListResponse.response;
          }else if(pos == 1) {
            stateToList = stateListResponse.response;
          }else{
            stateList = stateListResponse.response;
            stateToList = stateListResponse.response;
          }

          isLoading = false;
        });
      }else{
        Utility().showInSnackBar(value:  stateListResponse.message, context: context);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showInSnackBar(value: somethingWentWrong, context: context);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCityList( int pos) async {
    setState(() {
      isLoading = true;
    });

    if(pos == 0){
      cityList = [];
    } else{
      cityToList = [];
    }

    var jsonData = null;

    dynamic response = await HTTP.get(getCityListAPI( pos==0? countryCodeSpinner!:countryToCodeSpinner! , pos==0?stateCodeSpinner!:stateToCodeSpinner! ));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      City.CityListResponse cityListResponse =
      City.CityListResponse.fromJson(jsonData);

      if(cityListResponse.status != "false"){
        setState(() {

          if(pos ==0 ){
            cityList = cityListResponse.response;
          }else
            {
              cityToList = cityListResponse.response;
            }

          isLoading = false;
        });
      }else{
        Utility().showInSnackBar(value: cityListResponse.message, context: context);
        setState(() {
          isLoading = false;
        });
      }

    } else {
      Utility().showInSnackBar(value: somethingWentWrong, context: context);
      setState(() {
        isLoading = false;
      });
    }
  }

  timeSlotWidget() {
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
              hintText: selectTimeSlot,
              fillColor: Colors.white),
          value: slotTimeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectTimeSlot : "",
          items: timeSlotList
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

              slotTimeSpinner = value.toString();
             if(value == "Morning 6am - 12am"){
               sendTimeSlot = 'A';
             }else if(value == "Afternoon 12am - 4pm"){
               sendTimeSlot = 'B';
             }else if(value == "Evening 4pm - 8pm"){
               sendTimeSlot = 'C';
             }else if(value == "MidNight 8pm - 6am"){
               sendTimeSlot = 'D';
             }
            });

            print("object===>$slotTimeSpinner");
          },
        ));
  }

  localAddressWidget() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: localController,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: Localtxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  submitWidget() {
    return GestureDetector(
        onTap: () {
          validation();

        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: isSend
                ? const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
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

  textWidget(String value) {
    return Container(
      height: 20,
      child: robotoTextWidget(textval:value, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.bold),
    );
  }

  countryToListWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        height: 52,
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
          value:  countryToCodeSpinner ,
          validator: (value) =>
          value == null || value.isEmpty ? selectCountryCode : "",
          items: countryList
              .map(( ListItem) => DropdownMenuItem(
              value: ListItem.land1,
              child: robotoTextWidget(
                  textval: ListItem.landx50  +" " +ListItem.land1,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');


              countryToCodeSpinner = value.toString();
              stateToCodeSpinner = null;


              Utility().checkInternetConnection().then((connectionResult) async {
                if (connectionResult) {
                  getStateList(1);
                } else {
                  Utility()
                      .showInSnackBar(value:  checkInternetConnection, context: context);
                }
              });
            });
          },
        ),
      ),
    );
  }

  stateToListWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        height: 52,
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
              hintText: selectStateCode,
              fillColor: Colors.white),
          value: stateToCodeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectStateCode : "",
          items: stateToList
              .map(( ListItem) => DropdownMenuItem(
              value: ListItem.bland,
              child: robotoTextWidget(
                  textval: ListItem.bezei  +" " +ListItem.bland,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');

              stateToCodeSpinner = value.toString();
              cityToCodeSpinner = null;


              Utility().checkInternetConnection().then((connectionResult) async {
                if (connectionResult) {
                  getCityList(1);
                } else {
                  Utility()
                      .showInSnackBar(value:  checkInternetConnection, context: context);
                }
              });
            });
          },
        ),
      ),
    );
  }

  cityToListWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        height: 52,
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
              hintText: selectCityCode,
              fillColor: Colors.white),
          value: cityToCodeSpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectCityCode : "",
          items: cityToList
              .map(( ListItem) => DropdownMenuItem(
              value: ListItem.cityc,
              child: robotoTextWidget(
                  textval: ListItem.bezei  +" " +ListItem.cityc,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');
              cityToCodeSpinner = value.toString();
              for(var i = 0 ; i<cityToList.length ; i++){
                if(cityToCodeSpinner == cityToList[i].cityc){
                  toCity =  cityToList[i].bezei;
                }
              }
            });
          },
        ),
      ),
    );
  }

  void validation() {

    if(isHotel){
      countryToCodeSpinner = countryCodeSpinner;
      stateToCodeSpinner = stateCodeSpinner;
      cityToCodeSpinner = cityCodeSpinner;

      for(var i = 0 ; i<cityList.length ; i++){
        if(cityToCodeSpinner == cityList[i].cityc){
          toCity =  cityList[i].bezei;
          fromCity = cityList[i].bezei;
        }
      }
    }

    if(nameController.text.toString().isEmpty){
      Utility().showInSnackBar(value: "Enter "+ govtxt, context: context);
    }else if(slotTimeSpinner == null || slotTimeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectTimeSlot, context: context);
    }else if(bookingTypeSpinner == null || bookingTypeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectBookingTime, context: context);
    }else if(isHotel && localController.text.toString().isEmpty){
      Utility().showInSnackBar(value: "Enter "+ Localtxt, context: context);
    }else if(countryCodeSpinner == null || countryCodeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectCountryCode, context: context);
    }else if(stateCodeSpinner == null || stateCodeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectStateCode, context: context);
    }else if(cityCodeSpinner == null || cityCodeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectCityCode, context: context);
    }else if(countryToCodeSpinner == null || countryToCodeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectCountryCode, context: context);
    }else if(stateToCodeSpinner == null || stateToCodeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectStateCode, context: context);
    }else if(cityToCodeSpinner == null || cityToCodeSpinner!.isEmpty){
      Utility().showInSnackBar(value: selectCityCode, context: context);
    }else if(remarkController.text.toString().isEmpty){
      Utility().showInSnackBar(value: "Enter "+ remarktxt, context: context);
    }else {
      sendRequestToSap();
     }
  }

  Future<void> sendRequestToSap() async {
    sharedPreferences = await SharedPreferences.getInstance();
    travelRequest = TravelRequest( pernr: sharedPreferences.getString(userID).toString() , bookingType: sendBookingType!, empName: nameController.text.toString(), fromCountry: countryCodeSpinner!, fromDistr: cityCodeSpinner!, fromState: stateCodeSpinner!, toCountry: countryToCodeSpinner!, toDistr: cityToCodeSpinner!, toState: stateToCodeSpinner!, suggested: remarkController.text.toString(),
      travelFrom: fromCity!, travelTo: toCity!, departSlot: sendTimeSlot!, travelDateFrom:  selectedFromDate.toString(), travelDateTo:  selectedToDate.toString(),);

    String value = convert.jsonEncode(travelRequest).toString();
    sendTravelRequest = [];
    sendTravelRequest.add(value);
    print("sendTravelRequest===>${sendTravelRequest.toString()}");

    sendTravelRequestTOSap();
  }

  Future<void> sendTravelRequestTOSap() async {

    setState(() {
      isSend = true;
    });

    dynamic response = await HTTP.get(getTravelRequestAPI(sendTravelRequest.toString()));
    if (response != null && response.statusCode == 200)  {
      var jsonData = convert.jsonDecode(response.body);
      print("response1======> ${response.body.toString()}");
      TravelRequestResponse travelRequestResponse = TravelRequestResponse.fromJson(jsonData);

      print("response ======> ${travelRequestResponse.toString()}");

      if(travelRequestResponse.status.compareTo("true") == 0){
          Utility().showInSnackBar(value: travelRequestResponse.message, context: context);
          Navigator.pop(context);
          setState(() {
            isSend = false;
          });
      }else{
        Utility().showInSnackBar(value: travelRequestResponse.message, context: context);
        setState(() {
          isSend = false;
        });
      }


    }else{
      Utility().showToast(somethingWentWrong);
      setState(() {
        isSend = false;
      });
    }
  }

}
