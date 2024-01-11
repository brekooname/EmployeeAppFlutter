import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/TravelExpenses/addExpenses.dart';
import 'package:shakti_employee_app/TravelExpenses/model/dropDownList.dart';
import 'package:shakti_employee_app/TravelExpenses/model/trvaelExp.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/database/database_helper.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:shakti_employee_app/travelrequest/model/countrylistrequest.dart' as Country;
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';

class TravelExpensesScreen extends StatefulWidget {
  const TravelExpensesScreen({Key? key}) : super(key: key);

  @override
  State<TravelExpensesScreen> createState() => _TravelExpensesScreenState();
}

class _TravelExpensesScreenState extends State<TravelExpensesScreen> {

  bool isLoading = false ;
  DateTime datefrom = DateTime.now();
  String?  selectedFromDate, selectedToDate;
  TextEditingController targetDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;
  List<Country.Response> countryList = [];
  List<TaxCode> taxCode = [];
  List<ExpenseType> expenseType = [];
  List<CostCenter> costCenter = [];
  String? countryCodeSpinner = "IN" ,costCenterSpinner;
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
    getDropDownList();
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
      floatingActionButton:  FloatingActionButton.extended(

        backgroundColor: AppColor.themeColor,

        onPressed: (){

          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) => AddExpensesScreen(editTravelExpense: null, taxCode: taxCode, expenseType: expenseType,)))
              .then((value) => {getAllTraveExpenses()});

        },
        label: robotoTextWidget(textval: "Add Expenses", colorval: Colors.white, sizeval: 14, fontWeight: FontWeight.w400),

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

                  savedtravelExpense.length>0?_buildPosts(context):SizedBox(),
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
      height: 58,
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField(
        iconSize: 0,
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
        value:  costCenterSpinner ,
        validator: (value) =>
        value == null || value.isEmpty ? selectCostCenter : "",
        items: costCenter
            .map(( ListItem) => DropdownMenuItem(
            value: ListItem.kostlTxt,
            child: Container(
              width: MediaQuery.of(context).size.width/1.15,
                child: robotoTextWidget(
                      textval: ListItem.kostlTxt,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold),
              ),
            ),
               )
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            print('value=====>$value');

            costCenterSpinner = value.toString();

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
      Country.CountryListResponse countryListResponse =
      Country.CountryListResponse.fromJson(jsonData);
      setState(() {
        countryList = countryListResponse.response;

      });
    } else {
      Utility().showInSnackBar(value: somethingWentWrong, context: context);

    }
  }

  Future<List<Map<String, dynamic>>?> getAllTraveExpenses() async {
    savedtravelExpense=[];
    List<Map<String, dynamic>> listMap =
    await DatabaseHelper.instance.queryAllTravelExpenseTable();
    setState(() {
      listMap.forEach(
              (map) => savedtravelExpense.add(TravelExpenseModel.fromMap(map)));
    });

     // DatabaseHelper.instance.deleteDSREntry();

    print('savedtravelExpense=========>${savedtravelExpense.toString()}');
  }

  Widget _buildPosts(BuildContext context) {
    return  Column(
      children: [
        //searchbar
/*        Container(
          padding: EdgeInsets.all(8),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
        ),*/
        robotoTextWidget(textval: expensesList, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.bold),
        savedtravelExpense.length > 0
            ? ListView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListItem(index);
          },
          itemCount: savedtravelExpense.length,
          padding: const EdgeInsets.all(2),
        ):NoDataFound(),

      ],
    ) ;
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
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width/1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailWidget(from, savedtravelExpense[index].fromDate),
                    detailWidget(to, savedtravelExpense[index].toDate),
                    detailWidget(desc, savedtravelExpense[index].description ),
                    detailWidget(amonuttxt, savedtravelExpense[index].amount ),
                    detailWidget(currencytxt, savedtravelExpense[index].currency ),
                  ],
                ),
              ),

              Column(
                children: [
                  loadSVG("assets/svg/delete.svg",index,0),
                  SizedBox(
                    height: 10,
                  ),
                  loadSVG("assets/svg/pen.svg",index,1),
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }

  SizedBox NoDataFound() {
    return SizedBox(
        height: MediaQuery.of(context).size.height/2,
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

  detailWidget(String title, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.25,
      height: 25,
      child: Row(
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

  Widget loadSVG(String svg, int index, int pos) {
    return InkWell(
      onTap: (){
       if(pos == 0) {
         showDialog(
           context: context,
           builder: (BuildContext context) =>
               deleteRowFromTable(
                   context, index),
         );
       }else{
         Navigator.of(context)
             .push(MaterialPageRoute(
             builder: (context) => AddExpensesScreen(editTravelExpense: savedtravelExpense[index], taxCode: taxCode, expenseType: expenseType,)))
             .then((value) => {getAllTraveExpenses()});
       }
      },
      child: SvgPicture.asset(
        svg,
        width: 30,
        height: 30,
      ),
    );
  }

  Widget deleteRowFromTable(BuildContext context, int index) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              appName,
              style: const TextStyle(
                  color: AppColor.themeColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            removeTravelConfirmation,
            style: const TextStyle(
                color: AppColor.themeColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: robotoTextWidget(
                    textval: cancel,
                    colorval: AppColor.darkGrey,
                    sizeval: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    DatabaseHelper.instance.deleteRowTravelExpenseTable(savedtravelExpense[index].toMap());
                    getAllTraveExpenses();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: robotoTextWidget(
                    textval: confirm,
                    colorval: AppColor.whiteColor,
                    sizeval: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ]));
  }

  Future<void> getDropDownList()  async {


    var jsonData = null;

    dynamic response = await HTTP.get(getTravelDropDown());
    if (response != null && response.statusCode == 200) {
      jsonData = convert.jsonDecode(response.body);
      DropListModel dropListModel =
      DropListModel.fromJson(jsonData);
      setState(() {
        taxCode = dropListModel.taxCode;
        expenseType = dropListModel.expenseType;
       costCenter = dropListModel.costCenter;
      /*  print("taxCode==== ${taxCode.toString()}");
        print("expenseType===== ${expenseType.toString()}");
        print("costCenter===== ${costCenter.toString()}");*/
        isLoading = false;
      });
    } else {
      Utility().showInSnackBar(value: somethingWentWrong, context: context);
      setState(() {
        isLoading = false;
      });
    }
  }
}
