import 'package:flutter/material.dart';
import 'package:shakti_employee_app/home/model/firestoredatamodel.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Util/utility.dart';
import '../theme/color.dart';
import '../theme/string.dart';

class AppUpdateWidget extends StatefulWidget {

  AppUpdateWidget({Key? key,required this.appUrl}) : super(key: key);

  String appUrl;


  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _AppUpdateWidgetPageState();
}

class _AppUpdateWidgetPageState extends State<AppUpdateWidget> {
  
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: const Text(

              "App latest version are available on play store\n please update first and enjoy",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 14,fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  color: Colors.black),// This will not work
            textAlign: TextAlign.center,
            )
          ),
          okBtnWidget()

      ],),),
    );
  }
  okBtnWidget() {
    return GestureDetector(
      onTap: () {
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
            _launchUrl(widget.appUrl);
          } else {
            Utility()
                .showInSnackBar(value: checkInternetConnection, context: context);
          }
        });
        _launchUrl(widget.appUrl);
      },
      child: Container(
        height: 50,
        margin:
        const EdgeInsets.only(top: 20,left: 40,right: 40),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
              textval: OK,
              colorval: Colors.white,
              sizeval: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    setState(() {
      isLoading = true;
    });

    print("url====>${Uri.parse(_url)}");
    if (!await launchUrl(Uri.parse(_url) ,mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $_url');
    }

    setState(() {
      isLoading = false;
    });
  }
}