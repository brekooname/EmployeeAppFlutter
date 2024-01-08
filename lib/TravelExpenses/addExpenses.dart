import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/TravelExpenses/model/trvaelExp.dart';
import 'package:shakti_employee_app/database/database_helper.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/travelrequest/model/countrylistrequest.dart'
    as C;
import 'package:shakti_employee_app/travelrequest/model/citylistresponse.dart'
    as City;
import 'package:shakti_employee_app/travelrequest/model/statelistresponse.dart'
    as S;
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import '../Util/utility.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({Key? key}) : super(key: key);

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  bool isLoading = false, isHotel = false, isSend = false;
  List<C.Response> countryList = [];
  List<S.Response> stateList = [];
  List<S.Response> stateToList = [];
  List<City.Response> cityList = [];
  List<City.Response> cityToList = [];
  String? countryCodeSpinner = "IN",
      countryToCodeSpinner = "IN",
      stateCodeSpinner,
      taxCodeSpinner,
      cityCodeSpinner,
      fromCity,
      expenseTypeSpinner     ;

  TextEditingController nameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController localController = TextEditingController();
  TextEditingController locationController =TextEditingController();
  TextEditingController amountController =TextEditingController();
  TextEditingController currencyController =TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  DateTime datefrom = DateTime.now();
  String? selectedFromDate, selectedToDate ,currencySpinner;
  TextEditingController targetDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;

  var currencyList = [
    'India Rupee',
    'US Dollar',
  ];

  TravelExpenseModel? travelExpenseModel;


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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: travelEx,
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
      floatingActionButton:  FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        onPressed: (){

            saveDataToDatabase();
            Navigator.pop(context);
        },
        child: const Icon(Icons.check , color: AppColor.whiteColor,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      datePickerWidget(
                          fromDateController.text, fromDateController, "0"),
                      datePickerWidget(
                          toDateController.text, toDateController, "1")
                    ],
                  ),
                  countryListWidget(),
                  stateListWidget(),
                  cityListWidget(),
                  //Expense Type
                  ExpenseTypeListWidget(),
                  //Tax Code
                  taxCodeWidget(),
                  locationofTravel(),
                  amountWidget(),
                  currencyWidget(),
                  descriptionTravel() ,
                  GSTINNoWidget(),
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

  currencyWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10,),
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
              hintText: selectDayOrMore,
              fillColor: Colors.white),
          value: currencySpinner,
          validator: (value) =>
          value == null || value.isEmpty ? selectDayOrMore : "",
          items: currencyList
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
              currencySpinner = value.toString();
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
        firstDate: DateTime(1050),
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
    return Container(
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
        value: countryCodeSpinner,
        validator: (value) =>
            value == null || value.isEmpty ? selectCountryCode : "",
        items: countryList
            .map((ListItem) => DropdownMenuItem(
                value: ListItem.land1,
                child: Container(
                  child: robotoTextWidget(
                      textval: ListItem.landx50 + " " + ListItem.land1,
                      colorval: AppColor.themeColor,
                      sizeval: 12,
                      fontWeight: FontWeight.bold),
                  width: MediaQuery.of(context).size.width / 2,
                )))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            print('value=====>$value');

            countryCodeSpinner = value.toString();
            stateCodeSpinner = null;

            Utility()
                .checkInternetConnection()
                .then((connectionResult) async {
              if (connectionResult) {
                getStateList(0);
              } else {
                Utility().showInSnackBar(
                    value: checkInternetConnection, context: context);
              }
            });
          });
        },
      ),
    );
  }

  stateListWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        height: 58,
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
              .map((ListItem) => DropdownMenuItem(
                  value: ListItem.bland,
                  child: Container(
                    child: robotoTextWidget(
                        textval: ListItem.bezei + " " + ListItem.bland,
                        colorval: AppColor.themeColor,
                        sizeval: 12,
                        fontWeight: FontWeight.bold),
                    width: MediaQuery.of(context).size.width / 2,
                  )))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');

              stateCodeSpinner = value.toString();
              cityCodeSpinner = null;

              Utility()
                  .checkInternetConnection()
                  .then((connectionResult) async {
                if (connectionResult) {
                  getCityList(0);
                } else {
                  Utility().showInSnackBar(
                      value: checkInternetConnection, context: context);
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
      margin: const EdgeInsets.only(top: 10,),
      child: Container(
        height: 58,
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
              .map((ListItem) => DropdownMenuItem(
                  value: ListItem.cityc,
                  child: Container(
                    child: robotoTextWidget(
                        textval: ListItem.bezei + " " + ListItem.cityc,
                        colorval: AppColor.themeColor,
                        sizeval: 12,
                        fontWeight: FontWeight.bold),
                    width: MediaQuery.of(context).size.width / 2,
                  )))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              print('value=====>$value');
              cityCodeSpinner = value.toString();
              for (var i = 0; i < cityList.length; i++) {
                if (cityCodeSpinner == cityList[i].cityc) {
                  fromCity = cityList[i].bezei;
                }
              }
            });
          },
        ),
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

  Future<void> getStateList(int pos) async {
    setState(() {
      isLoading = true;
    });

    if (pos == 0) {
      stateList = [];
    } else if (pos == 1) {
      stateToList = [];
    } else {
      stateList = [];
      stateToList = [];
    }

    var jsonData = null;

    dynamic response = await HTTP.get(getStateListAPI(pos == 2
        ? countryCodeSpinner!
        : pos == 1
            ? countryToCodeSpinner!
            : pos == 0
                ? countryCodeSpinner!
                : countryToCodeSpinner!));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      S.StateListResponse stateListResponse =
          S.StateListResponse.fromJson(jsonData);

      //  print("object===> ${stateListResponse.toString()}");

      if (stateListResponse.status.compareTo("true") == 0) {
        setState(() {
          if (pos == 0) {
            stateList = stateListResponse.response;
          } else if (pos == 1) {
            stateToList = stateListResponse.response;
          } else {
            stateList = stateListResponse.response;
            stateToList = stateListResponse.response;
          }

          isLoading = false;
        });
      } else {
        Utility()
            .showInSnackBar(value: stateListResponse.message, context: context);
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

  Future<void> getCityList(int pos) async {
    setState(() {
      isLoading = true;
    });

    if (pos == 0) {
      cityList = [];
    } else {
      cityToList = [];
    }

    var jsonData = null;

    dynamic response = await HTTP.get(getCityListAPI(
        pos == 0 ? countryCodeSpinner! : countryToCodeSpinner!,
         stateCodeSpinner!  ));
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      City.CityListResponse cityListResponse =
          City.CityListResponse.fromJson(jsonData);

      if (cityListResponse.status != "false") {
        setState(() {
          if (pos == 0) {
            cityList = cityListResponse.response;
          } else {
            cityToList = cityListResponse.response;
          }

          isLoading = false;
        });
      } else {
        Utility()
            .showInSnackBar(value: cityListResponse.message, context: context);
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

  ExpenseTypeListWidget() {
    return Container(
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
        value: expenseTypeSpinner,
        validator: (value) =>
            value == null || value.isEmpty ? selectCountryCode : "",
        items: countryList
            .map((ListItem) => DropdownMenuItem(
                value: ListItem.land1,
                child: Container(
                  child: robotoTextWidget(
                      textval: ListItem.landx50 + " " + ListItem.land1,
                      colorval: AppColor.themeColor,
                      sizeval: 12,
                      fontWeight: FontWeight.bold),
                  width: MediaQuery.of(context).size.width / 2,
                )))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            print('value=====>$value');

            expenseTypeSpinner = value.toString();
          });
        },
      ),
    );
  }

  taxCodeWidget() {
    return Container(
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
        value: taxCodeSpinner,
        validator: (value) =>
        value == null || value.isEmpty ? selectCountryCode : "",
        items: countryList
            .map((ListItem) => DropdownMenuItem(
            value: ListItem.land1,
            child: Container(
              child: robotoTextWidget(
                  textval: ListItem.landx50 + " " + ListItem.land1,
                  colorval: AppColor.themeColor,
                  sizeval: 12,
                  fontWeight: FontWeight.bold),
              width: MediaQuery.of(context).size.width / 2,
            )))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            print('value=====>$value');

            taxCodeSpinner = value.toString();
          });
        },
      ),
    );
  }

  locationofTravel() {
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
        textInputAction: TextInputAction.next,
      ),
    );
  }

  amountWidget() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: amountController,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.attach_money,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: amonuttxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 14),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
    );
  }


  descriptionTravel() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextField(
        controller: descController,
        style: const TextStyle(color: AppColor.themeColor),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.edit_note,
            color: AppColor.themeColor,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: descriptiontxt,
          hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  GSTINNoWidget() {
    return Container(
    height: 50,
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.themeColor),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: TextField(
      controller: gstController,
      style: const TextStyle(color: AppColor.themeColor),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.monetization_on_outlined,
          color: AppColor.themeColor,
          size: 20,
        ),
        border: InputBorder.none,
        hintText: GSTINNotxt,
        hintStyle: const TextStyle(color: AppColor.themeColor, fontSize: 12),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    ),
  );
  }

  void saveDataToDatabase() {
    TravelExpenseModel travelExpenseModel = TravelExpenseModel(fromDate: fromDateController.text.toString(), toDate: toDateController.text.toString(), country: countryCodeSpinner!, state: stateCodeSpinner!, city: cityCodeSpinner!, expenseType: expenseTypeSpinner!, taxCode: taxCodeSpinner!, location: locationController.text.toString(), amount: amountController.text.toString(), currency: currencyController.text.toString(), description: descController.text.toString(), gstNo: gstController.text.toString());

    print("travelExpenseModelEntry===>${travelExpenseModel.toString()}");

    DatabaseHelper.instance.insertTravelExpenseTable(travelExpenseModel.toMapWithoutId());
    //String value = convert.jsonEncode(sendDsrEntry).toString();


  }


}
