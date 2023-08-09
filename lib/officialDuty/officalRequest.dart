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
import '../home/HomePage.dart';
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

  DateTime selectedDate = DateTime.now();
  DateTime datefrom = DateTime.now(), dateto = DateTime.now();
  String ? indianFromDate,indianToDate ,selectedAssginTo;

  String dutyTypeSpinner = 'On Duty';

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

    indianFromDate =  DateFormat("dd/MM/yyyy").format(DateTime.now());
    indianToDate =  DateFormat("dd/MM/yyyy").format(DateTime.now());
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
            icon: new Icon(Icons.arrow_back, color: AppColor.whiteColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );}
        ),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            children: [

              dutyTypeSpinnerWidget(),
              const SizedBox(height: 10,),
              datePickerWidget("OD From",indianFromDate.toString()),
              const SizedBox(height: 10,),
              datePickerWidget("OD To",indianToDate.toString()),
              textFeildWidget( "Visit Place", visitPlace),
              WorkPlaceSpinnerWidget(),
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
      margin: const EdgeInsets.all(10),
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
          hintStyle: TextStyle(color: AppColor.themeColor, fontWeight: FontWeight.normal),
          prefixIcon: Icon(Icons.person, color: AppColor.themeColor,),
          border: InputBorder.none,
        ),
        onSubmit: (String value) {
          setState(() {
            selectedAssginTo = value.toString();
          });

          print("submitted\n ${value}"); },
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
          margin: const EdgeInsets.symmetric(
              horizontal: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.themeColor),
          child: Center(
            child: isLoading
                ? Container(
              height: 30,
              width: 30,
              child:
              const CircularProgressIndicator(
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
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(height: 0,),
          value: dutyTypeSpinner,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: dutyTypeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 18, fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              dutyTypeSpinner = newValue!;
            });
          },
        ),
      ),);
  }

  datePickerWidget( String text, String date) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height/20,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.whiteColor,
              ),
              onPressed: () => _selectDate(context,text),
              child:  robotoTextWidget(textval: text, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15.0,),
            robotoTextWidget(textval: date.toString(), colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.normal)
          ],
        ),
      ),

    );
  }

  Future<void> _selectDate(BuildContext context, String text) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget ?child) {
          return Theme(
            data: ThemeData(
              splashColor: Colors.black,
              textTheme: const TextTheme(
                titleSmall: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
              ),
              dialogBackgroundColor: Colors.white, colorScheme: const ColorScheme.light(
                primary: Color(0xff1565C0),
                primaryContainer: Colors.black,
                secondaryContainer: Colors.black,
                onSecondary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.black,
                onSurface: Colors.black,
                secondary: Colors.black).copyWith(primaryContainer: Colors.grey, secondary: Colors.black),
            ),
            child: child ??const Text(""),
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2026));
    if (picked != null && picked != selectedDate) {
      setState(() {

        if(text == "OD From"){
          datefrom = picked;
          indianFromDate =  DateFormat("dd/MM/yyyy").format(picked);
          print("indianDate===> ${indianFromDate}");
        }else if(text == "OD To"){
          dateto = picked;
          indianToDate =  DateFormat("dd/MM/yyyy").format(picked);
          print("indianDate===> ${indianToDate}");
        }

        print("indianDate1===> ${datefrom}");
        print("indianDate2===> ${dateto}");
      });
    }
  }

  textFeildWidget(String hinttxt, TextEditingController visitPlace) {
    return  Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      child:  TextField(
        controller: visitPlace,
        style: const TextStyle(color: AppColor.themeColor),
        decoration:  InputDecoration(
          prefixIcon: const Icon(
            Icons.person,
            color: AppColor.themeColor,
          ),
          border: InputBorder.none,
          hintText: hinttxt,
          hintStyle:
          const TextStyle(color: AppColor.themeColor),
        ),
        keyboardType: TextInputType.text,

      ),
    );
  }

  personInCharge() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      child:  TextField(
        controller: visitPlace,
        style: const TextStyle(color: AppColor.themeColor),
        decoration:  const InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: AppColor.themeColor,
          ),
          border: InputBorder.none,
          hintText: "Charge Given To",
          hintStyle:
          TextStyle(color: AppColor.themeColor),
        ),
        keyboardType: TextInputType.text,

      ),
    );
  }

  WorkPlaceSpinnerWidget()  {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 10,right: 10,bottom: 6,top: 10),
      child:   Center(
        child: DropdownButton(
          // Initial Value
          underline: const SizedBox(height: 0,),
          value: workPlace,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.themeColor, // <-- SEE HERE
          ),
          // Array list of items
          items: workplaceList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(child: robotoTextWidget(textval: items, colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400)),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              workPlace = newValue!;
            });
          },
        ),
      ),);
  }

  void Validation() {
    //Validation

    if(visitPlace.text.toString().isEmpty ) {
      Utility().showToast("Please enter visit Place");
    }else if(dateto.compareTo(datefrom) < 0){
      Utility().showToast("To date can not be smaller then From date");
    }if(workPlace ==  "Select Work Place") {
      Utility().showToast("Please select Department");
    }else  if(purpose1.text.toString().isEmpty){
      Utility().showToast("Please enter Purpose");
    }else  if(remark.text.toString().isEmpty){
      Utility().showToast("Please enter Remark");
    } else {
      setState(() {
        print("Duty Type ${dutyTypeSpinner.toString()}");
        print("OD Date ${indianFromDate.toString()}");
        print("OD to Date ${indianToDate.toString()}");
        print("visitPlace ${visitPlace.text.toString()}");
        print("workPlace ${workPlace.toString()}");
        print("purpose1 ${purpose1.text.toString()}");
        print("purpose2 ${purpose2.text.toString()}");
        print("remark ${remark.text.toString()}");
        print("personInChanger ${remark.text.toString()}");
      });

      createOD();
    }
  }

  Future<void> createOD() async {

   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? sapcode = sharedPreferences.getString(userID).toString() ;

    dynamic response = await HTTP.get(createODAPI(sapcode!,dutyTypeSpinner.toString(),indianFromDate.toString(),indianToDate.toString(),visitPlace.text.toString(),workPlace.toString(),purpose1.text.toString(),purpose2.text.toString(),purpose3.text.toString(),remark.text.toString(),selectedAssginTo.toString()));
    if (response != null && response.statusCode == 200)  {

      print("response======>${response.toString()}");
      Iterable l = convert.json.decode(response.body);
      List<OdResponse> odResponse = List<OdResponse>.from(l.map((model)=> OdResponse.fromJson(model)));
      print("response======>${odResponse[0].name}");

      if(odResponse[0].name.compareTo("SAPLSPO1") == 0){

        Utility().showToast("OD Created Successfully");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    HomePage()),
                (route) => true);

      }else{
        Utility().showToast(odResponse[0].name);
      }
    }
  }



}
