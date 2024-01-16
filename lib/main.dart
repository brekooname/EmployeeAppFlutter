import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shakti_employee_app/Util/utility.dart';
import 'package:shakti_employee_app/firebase_options.dart';
import 'package:shakti_employee_app/loginModel/LoginModel.dart';
import 'package:shakti_employee_app/provider/BackgroundLocationService.dart';
import 'package:shakti_employee_app/provider/firestore_appupdate_notifier.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/appupdatewidget.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:shakti_employee_app/webservice/APIDirectory.dart';
import 'package:shakti_employee_app/webservice/HTTP.dart' as HTTP;
import 'package:shakti_employee_app/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password/forgot_password_page.dart';
import 'home/home_page.dart';
import 'home/model/firestoredatamodel.dart';
import 'notificationService/local_notification_service.dart';
import 'theme/string.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? isLoggedIn =
      (sharedPreferences.getString(userID) == null) ? False : True;
  String? journeyStarts =
      (sharedPreferences.getString(localConveyanceJourneyStart) == null)
          ? False
          : sharedPreferences.getString(localConveyanceJourneyStart);
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    journStar: journeyStarts,
  ));
}

class MyApp extends StatelessWidget {
  String? isLoggedIn, journStar;

  MyApp({Key? key, required this.isLoggedIn, required this.journStar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => firestoreAppUpdateNofifier()),
          ChangeNotifierProvider(create: (_) => BackgroundLocationService()),
        ],
        child: MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue
          ),
          home: isLoggedIn == True
              ? HomePage(
                  journeyStart: journStar!,
                )
              : const LoginPage(),
        ),);
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
  String platform = '',
      appVersion = '',
      appVersionCode = '',
      fcmToken = '',
      imeiNumber = '',
      apiNumber = '',
      platformVersion = '',     loginUserType ='';
  TextEditingController sapCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool getPermission = false;
  FirestoreDataModel? fireStoreDataModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        retrieveFCMToken();
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   return Consumer<firestoreAppUpdateNofifier>(
        builder: (context, value, child) {
      if (value.fireStoreData != null && value.fireStoreData!.minEmployeeAppVersion !=
          value.appVersionCode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => AppUpdateWidget(
                      appUrl:
                      value.fireStoreData!.employeeAppUrl.toString())),
                  (Route<dynamic> route) => false);

        });
      } else {
        return Scaffold(
          body: Container(
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
                                height: 10,
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
        );
      } return Container(
      );
        });
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
        const SizedBox(
          height: 10,
        ),
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
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.themeColor,
                ),
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

    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "IOS";
    }
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(packageInfo.packageName =="shakti.shakti_employee"){
      loginUserType = 'ONROLL';
    }else{
      loginUserType = 'OFFROLL';
    }

    dynamic response = await HTTP.get(userLogin(
        sapCodeController.text.toString(),
        passwordController.text.toString().toUpperCase(),
        platformVersion,
        apiNumber,
        appVersion,
        imeiNumber,
        platform,
        fcmToken,
        loginUserType));

    if (response != null && response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<LoginModelResponse> loginResponse = List<LoginModelResponse>.from(
          l.map((model) => LoginModelResponse.fromJson(model)));

      print('Response======>${response.body}');
      if(loginResponse[0].name.isNotEmpty){
        loginResManage(loginResponse[0]);
      } else {
        Utility().showToast(errorMssg);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Utility().showToast(somethingWentWrong);
      setState(() {
        isLoading = false;
      });
    }
  }

  void loginResManage(LoginModelResponse loginResponse) {
    Utility().setSharedPreference(userID, sapCodeController.text.toString());
    Utility().setSharedPreference(password, passwordController.text.toString());

    Utility().setSharedPreference(name, loginResponse.name);
    Utility().setSharedPreference(localConveyanceJourneyStart, 'false');
    Utility().showToast(welcome + loginResponse.name);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePage(
              journeyStart: False,
            )),
            (route) => false);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> retrieveFCMToken() async {
    FirebaseMessaging.instance.getToken().then((token) {
      final tokenStr = token.toString();
      // do whatever you want with the token here
      fcmToken = tokenStr;
      print('tokenStr==========>$tokenStr');
    });
    readNotifier();
    _deviceDetails();
  }

  void readNotifier() {
    context.read<firestoreAppUpdateNofifier>().listenToLiveUpdateStream();
  }

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          apiNumber = build.version.sdkInt.toString();
          platformVersion = build.version.release;
          imeiNumber = build.id;
          appVersion = packageInfo.version;
          appVersionCode = packageInfo.buildNumber;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          apiNumber = data.utsname.version;
          platformVersion = data.systemVersion;
          imeiNumber = data.identifierForVendor!;
          appVersion = packageInfo.version;
          appVersionCode = packageInfo.buildNumber;
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

}
