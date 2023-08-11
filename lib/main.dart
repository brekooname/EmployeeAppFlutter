import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/loginModel/LoginModel.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shakti_employee_app/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password/forgot_password_page.dart';
import 'home/HomePage.dart';
import 'theme/string.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? isLoggedIn = (sharedPreferences.getString(userID) == null) ? False : True;
  String? journeyStarts = (sharedPreferences.getString(journeyStart) == null) ? False : sharedPreferences.getString(journeyStart);
  runApp(MyApp(isLoggedIn: isLoggedIn,journStar: journeyStarts,));
}

class MyApp extends StatelessWidget {
  String? isLoggedIn,journStar;

  MyApp({Key? key, required this.isLoggedIn,required this.journStar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.themeColor),
      ),
      home: isLoggedIn == True ? HomePage(journeyStart: journStar!,) : const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false, isScreenVisible = false;
  bool isPasswordVisible = false;

  TextEditingController sapCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColor.whiteColor),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/applogo.svg",
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           robotoTextWidget(
                              textval: Login,
                              colorval: AppColor.themeColor,
                              sizeval: 30,
                              fontWeight: FontWeight.bold),
                          const SizedBox(
                            height:10,
                          ),
                          emailPasswordWidget(),
                          const SizedBox(
                            height: 10,
                          ),
                          forgotPasswordWidget(),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              signIn();
                            },
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColor.themeColor),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: AppColor.whiteColor,
                                        ),
                                      )
                                    : robotoTextWidget(
                                        textval: login,
                                        colorval: Colors.white,
                                        sizeval: 14,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
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

  Column emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: sapCodeController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
            ],
            style: const TextStyle(color: AppColor.themeColor),
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: AppColor.themeColor,
              ),
              border: InputBorder.none,
              hintText: 'Sap Login',
              hintStyle: TextStyle(color: AppColor.themeColor),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: passwordController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            style: const TextStyle(
              color: AppColor.themeColor,
            ),
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: password,
              hintStyle: const TextStyle(color: AppColor.themeColor),
              prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lock,
                    color: AppColor.themeColor,
                  )),
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,color: AppColor.themeColor,),
                onPressed: () {
                  setState(
                    () {
                      isPasswordVisible = !isPasswordVisible;
                    },
                  );
                },
              ),
              alignLabelWithHint: false,
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }


  forgotPasswordWidget() {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const ForgotPasswordPage()),
              (Route<dynamic> route) => true);
          //   signIn();
        },
        child: Container(
          height: 30,
          child: Align(
            alignment: Alignment.centerRight,
            child: robotoTextWidget(
                textval: forgotPassword,
                colorval: Colors.grey,
                sizeval: 12,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  signupWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              robotoTextWidget(
                  textval: dontHaveAccount,
                  colorval: Colors.grey,
                  sizeval: 12,
                  fontWeight: FontWeight.bold),
            ],
          )),
    );
  }

  Future<void> signIn() async {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (sapCodeController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: sapcodeempty, context: context);
        } else if (passwordController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: passwordMessage, context: context);
        } else {
          loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Future<void> loginAPI() async {
    setState(() {
      isLoading = true;
    });

    Utility().setSharedPreference(userID, sapCodeController.text.toString());
    Utility().setSharedPreference(password, passwordController.text.toString());

    dynamic response = await HTTP.get(userLogin(
        sapCodeController.text.toString(), passwordController.text.toString()));
    if (response != null && response.statusCode == 200) {
       Iterable l = json.decode(response.body);
      List<LoginModelResponse> loginResponse = List<LoginModelResponse>.from(
          l.map((model) => LoginModelResponse.fromJson(model)));

      if (loginResponse[0].name.isNotEmpty) {
        Utility().setSharedPreference(name, loginResponse[0].name);
        Utility().setSharedPreference(journeyStart,'false');
        Utility().showToast('Welcome ' + loginResponse[0].name);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage(journeyStart: False,)),
            (route) => false);

        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast("Wrong User Id /Password, Try Again");
        setState(() {
          isLoading = false;
        });
      }
    }else {
      Utility().showToast("Something Went Wrong Please Try Again");
      setState(() {
        isLoading = false;
      });
    }
  }
}
