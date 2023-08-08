import 'dart:async';
import 'dart:math';

import 'package:shakti_employee_app/forgot_password/model/otpreponse.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';

import '../../Util/utility.dart';
import '../../uiwidget/robotoTextWidget.dart';
import 'reset_password/resetpasswordpage.dart';

class EnterOTPPage extends StatefulWidget {
  int otp;
  String mobile;

  EnterOTPPage({Key? key, required this.otp, required this.mobile}) : super(key: key);

  @override
  State<EnterOTPPage> createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  bool isLoading = false, isScreenVisible = false;
  TextEditingController otpController = TextEditingController();
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 60;
  int currentSeconds = 0;
  bool isTimerStart = false;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        isTimerStart = true;
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds){
          print('TimerStopped====>${timer.tick}');
          isTimerStart = false;
          timer.cancel();}


      });
    });
  }

  @override
  void initState() {
    startTimeout();
    print("widget.mobile");

    print(widget.mobile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.themeColor,
            elevation: 0,
            title: robotoTextWidget(
                textval: OTPTitle,
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
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/shield.svg",
                          width: 150,
                          height: 150,
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
                                  topRight: Radius.circular(60)),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(top: 80),
                              child: Column(
                                children: [
                                  Text(verfiyOTP, textAlign: TextAlign.center,style: const TextStyle(color:Colors.grey,
                                      fontSize: 12,fontWeight: FontWeight.w600)),
                                  otpTextWidget(),
                                  resendOtpTimeWidget(),
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
                                                  textval: OTPTitle,
                                                  colorval: Colors.white,
                                                  sizeval: 14,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Container otpTextWidget() {
    return Container(
        margin: const EdgeInsets.all(20),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.phonelink_ring_sharp,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                          hintText: otpMessage,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> signIn() async {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {

        if (otpController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: otpMessage, context: context);
        } else if (otpController.text.toString().length != 4) {
          Utility().showInSnackBar(value: invaildOtp, context: context);
        } else if( !isTimerStart ){
          widget.otp = 0;
          Utility().showInSnackBar(value: resendMess, context: context);
        } else if (widget.otp == 0){
          Utility().showInSnackBar(value: resendMess, context: context);
        }else if (otpController.text
                .toString()
                .compareTo(widget.otp.toString()) != 0) {
          Utility().showInSnackBar(value: otpnotmatch, context: context);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>  ResetPasswordPage()),
                  (Route<dynamic> route) => true);
          // loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Container resendOtpTimeWidget() {
    return Container(
      height: 45,
      margin: const EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isTimerStart!=null && isTimerStart==false? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  robotoTextWidget(textval: resendOtpMess, colorval:  Colors.grey, sizeval: 12, fontWeight: FontWeight.normal),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    child: robotoTextWidget(textval: resendOtp, colorval: AppColor.themeColor, sizeval: 12, fontWeight: FontWeight.normal),
                    onTap: (){
                      Random random = Random();
                      widget.otp = random.nextInt(9999 - 1000 )+1000;
                      print("Number===>${widget.otp.toString()}");

                      startTimeout();
                      sendOtpAPI();
                    },
                  ),

                ],
              ):SizedBox(),
          isTimerStart!=null && isTimerStart==true?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.timer, color: AppColor.themeColor),
              SizedBox(
                width: 5,
              ),
              robotoTextWidget(textval: timerText, colorval: AppColor.themeColor, sizeval: 12, fontWeight: FontWeight.normal),

            ],
          ):SizedBox(),
        ],
      )
    );
  }

  Future<void> sendOtpAPI() async {
    setState(() {
      isLoading = true;
    });

    var jsonData = null;
    dynamic response = await HTTP.get(sendOTPAPI(widget.mobile,widget.otp));
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      jsonData = convert.jsonDecode(response.body);

      OtpResponse otpResponse = OtpResponse.fromJson(jsonData);

      if (otpResponse.status.compareTo("Success") == 0 ) {
        Utility().showToast("OTP Send SuccessFully");

      } else {
        Utility().showInSnackBar(value: otpResponse.description, context: context);
        Utility().showToast(otpResponse.description);
      }
    } else {
      if (!mounted) return;
      Utility().showInSnackBar(value: 'Unable To Login', context: context);
    }
  }
}
