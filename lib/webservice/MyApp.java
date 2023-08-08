package webservice;

import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/Util/utility.dart';
import 'package:grid_tie/login_forgotpassword/forgot_password/forgot_password_page.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/homepage.dart';
import 'login_forgotpassword/model/loginmodel.dart';
import 'registeruser/registeruserpge.dart';
import 'webservice/APIDirectory.dart';
import 'webservice/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? isLoggedIn = (prefs.getString(userID) == null) ? 'false' : 'true';
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp(isLoggedIn: isLoggedIn));
  });

}

class MyApp extends StatelessWidget {
  String? isLoggedIn;

  MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn == 'true' ? HomePage() : LoginPage(),
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

  TextEditingController emailUserNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
         child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColor.themeColor),
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
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 60,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(30, 136, 229, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: emailPasswordWdget(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            forgotPasswordWidget(),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                                onTap: () {
                                  signIn();
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
                                            textval: login,
                                            colorval: Colors.white,
                                            sizeval: 14,
                                            fontWeight: FontWeight.bold),
                                  ),
                                )),
                            signupWidget()
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

  Column emailPasswordWdget() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: TextField(
            controller: emailUserNameController,
            maxLines: 1,
            decoration: InputDecoration(
                hintText: emailUserName,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: TextField(
            controller: passwordController,
            maxLines: 1,
            maxLength: 30,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              hintText: password,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
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
      margin: EdgeInsets.all(10),
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
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                   Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(
                     builder: (BuildContext context) => const RegisterUserPage()),
                     (Route<dynamic> route) => true);
                },
                child: Container(
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: robotoTextWidget(
                        textval: register,
                        colorval: AppColor.themeColor,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> signIn() async {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (emailUserNameController.text.toString().isEmpty) {
          Utility()
              .showInSnackBar(value: emailNameValidation, context: context);
        } else if (passwordController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: passwordValidation, context: context);
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "userName": emailUserNameController.text.toString(),
      "userPass": passwordController.text.toString(),
    };

    print("LoginInput==============>${data.toString()}");
    var jsonData = null;
    dynamic response = await HTTP.post(userLogin(), data);
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      jsonData = convert.jsonDecode(response.body);

      LoginModel loginModel = LoginModel.fromJson(jsonData);

      if (loginModel.status == true && loginModel.response != null) {
        sharedPreferences.setString(
            userID, loginModel.response!.userId.toString());
        sharedPreferences.setString(
            userName, loginModel.response!.userName.toString());
        sharedPreferences.setString(
            userEmail, loginModel.response!.email.toString());
        sharedPreferences.setString(
            userMobile, loginModel.response!.mobile.toString());
        sharedPreferences.setString(
            userRoleId, loginModel.response!.roleId.toString());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage()),
            (Route<dynamic> route) => false);
      } else {
        Utility().showInSnackBar(value: loginModel.message, context: context);
      }
    } else {
      if (!mounted) return;
      Utility().showInSnackBar(value: 'Unable To Login', context: context);
    }
  }
}
