import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/forgot_password/forgot_password_page.dart';
import 'package:shakti_employee_app/forgot_password/reset_password/model/updatepasswordresponse.dart';

import 'package:shakti_employee_app/main.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;

import '../../Util/utility.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../webservice/constant.dart';

class ResetPasswordPage extends StatefulWidget {

  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ResetPasswordPage> {
  bool isLoading = false, isScreenVisible = false;
  bool isPasswordVisible = false;

  DateTime selectedDate = DateTime.now();
  late String indianDate ;


  TextEditingController sapCode = TextEditingController();
  TextEditingController mobileNo = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indianDate =  DateFormat("dd/MM/yyyy").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColor.themeColor,
              elevation: 0,
              title: robotoTextWidget(
                  textval: resetPasswordTitle,
                  colorval: AppColor.whiteColor,
                  sizeval: 15,
                  fontWeight: FontWeight.w800)),
          body: SizedBox(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColor.themeColor),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/svg/password.svg",
                            width: 100,
                            height: 100,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.only(top: 60),
                                child: Column(
                                  children: [
                                    Text(resetPasswordDesc, textAlign: TextAlign.center,style: const TextStyle(color:Colors.grey,
                                        fontSize: 12,fontWeight: FontWeight.w600)),
                                    SizedBox( height: 20,),
                                    datePickerWidget(),
                                    SizedBox( height: 10,),
                                    PasswordTextWdget(),
                                    editMobileWidget(),
                                    GestureDetector(
                                      onTap: () {
                                        signIn();
                                      },
                                      child: Container(
                                        height: 50,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                                                  textval: change,
                                                  colorval: Colors.white,
                                                  sizeval: 14,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Container PasswordTextWdget() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(30, 136, 229, .3),
                blurRadius: 20,
                offset: Offset(0, 10))
          ]),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: TextField(
              controller: sapCode,
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: userID,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: TextField(
              controller: mobileNo,
              decoration: InputDecoration(
                hintText: mobileNotxt,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                alignLabelWithHint: false,
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }

  Container editMobileWidget() {
    return Container(
      height: 45,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          robotoTextWidget(
              textval: editMobile,
              colorval: Colors.grey,
              sizeval: 12,
              fontWeight: FontWeight.normal),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            child: robotoTextWidget(
                textval: edit,
                colorval: AppColor.themeColor,
                sizeval: 12,
                fontWeight: FontWeight.normal),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const ForgotPasswordPage()),
                  (Route<dynamic> route) => true);
            },
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
         if (mobileNo.text.toString().isEmpty) {
          Utility().showInSnackBar(value: mobileNoMessage, context: context);
        }else if (mobileNo.text.toString().length<10) {
          Utility().showInSnackBar(value: invaildMobileNo, context: context);
        }else if (sapCode.text.toString().isEmpty) {
           Utility().showInSnackBar(value: sapcodeempty, context: context);
         } else {
          updatePassword();
          // loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Future<void> updatePassword() async {
    setState(() {
      isLoading = true;
    });

    var jsonData = null;
    dynamic response = await HTTP.get(forgotpasword(sapCode.text.toString(),mobileNo.text.toString(),indianDate.toString()));
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      Iterable l = json.decode(response.body);
      List<UpdatePasswordResponse> updatepassword = List<UpdatePasswordResponse>.from(l.map((model)=> UpdatePasswordResponse.fromJson(model)));
      print("response======>${updatepassword[0].msg}");

      if (updatepassword[0].msg != null && updatepassword[0].msg != "Enter correct registered Mob no." && updatepassword[0].msg !="Wrong DOB") {
        Utility().showToast(updatepassword[0].msg);

       /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => true);*/
      }else if (updatepassword[0].msg == "Enter correct registered Mob no." || updatepassword[0].msg !="Wrong DOB"){
        Utility().showToast(updatepassword[0].msg);
      }
      else {


        Utility().showToast(updatepassword[0].msg);
      }
    }
  }

  datePickerWidget() {
    return SizedBox(

      width: double.infinity,
      height: MediaQuery.of(context).size.height/20,
      child:    Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.whiteColor,
              ),
              onPressed: () => _selectDate(context),
              child: const robotoTextWidget(textval: 'Select date of DOB', colorval: AppColor.themeColor, sizeval: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15.0,),
            robotoTextWidget(textval: indianDate.toString(), colorval: AppColor.themeColor, sizeval: 20, fontWeight: FontWeight.normal)
          ],
        ),
      ),

    );
  }

  Future<void> _selectDate(BuildContext context) async {
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
        firstDate: DateTime(1950),
        lastDate: DateTime(2024));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        indianDate =  DateFormat("dd/MM/yyyy").format(picked);
        print("indianDate===> ${indianDate}");
      });
    }
  }



}
