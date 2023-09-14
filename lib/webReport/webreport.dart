import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shakti_employee_app/webReport/webpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/constant.dart';

class WebReport extends StatefulWidget {
  const WebReport({Key? key}) : super(key: key);

  @override
  State<WebReport> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebReport> {
  String? sapCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title:  robotoTextWidget(
            textval: webReport,
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
      body: optionWidget(),
    );
  }

  optionWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        color: AppColor.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            detailWidget(about, aboutdec, "assets/svg/restaurant.svg",
                '$webBaseURL$canteenUrl?perno=$sapCode'),
            const SizedBox(
              height: 5,
            ),
            lineWidget(),
            detailWidget(gatePass, gatePassdec, "assets/svg/clipboard.svg",
                '$webBaseURL$gatePassUrl?perno=$sapCode'),
            const SizedBox(
              height: 5,
            ),
            lineWidget(),
            detailWidget(taskReport, taskReportdec, "assets/svg/clipboard.svg",
                '$webBaseURL$taskUrl?perno=$sapCode'),
            lineWidget(),
            detailWidget(
                emphierarchy,
                emhierarchydec,
                "assets/svg/hierarchy.svg",
                '$webBaseURL$emphierarchyUrl?perno=$sapCode'),
          ],
        ),
      ),
    );
  }

  lineWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
    );
  }

  detailWidget(String title, String description, String svg, String url) {
    return InkWell(
      onTap: () {
        if (url.isNotEmpty) {
          Utility().checkInternetConnection().then((connectionResult) {
            if (connectionResult) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => WebPage(
                        title: title,
                        url: url,
                      )),
                      (route) => true);
            } else {
              Utility()
                  .showInSnackBar(value: checkInternetConnection, context: context);
            }
          });

        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 13,
        margin: const EdgeInsets.only(right: 10, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  svg,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    robotoTextWidget(
                        textval: title,
                        colorval: AppColor.themeColor,
                        sizeval: 15,
                        fontWeight: FontWeight.bold),
                    robotoTextWidget(
                        textval: description,
                        colorval: Colors.grey,
                        sizeval: 10,
                        fontWeight: FontWeight.bold)
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      sapCode = sharedPreferences.getString(userID).toString();
    });
  }
}
