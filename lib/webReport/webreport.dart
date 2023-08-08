import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakti_employee_app/home/HomePage.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:url_launcher/url_launcher.dart';

import '../uiwidget/robotoTextWidget.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  //  _launchUrl('https://spprdsrvr1.shaktipumps.com:8423/sap(bD1lbiZjPTkwMA==)/bc/bsp/sap/zhr_emp_app_web/dashboard.htm');

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: robotoTextWidget(
            textval: ""
                "Web Report",
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
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: optionWidget(),
    );;
  }


  optionWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20),
      color: AppColor.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            lineWidget(),
            detailWidget(
                about, aboutdec, "assets/svg/restaurant.svg", webBaseURL+canteenUrl),
            const SizedBox(
              height: 5,
            ),
            lineWidget(),
            detailWidget(gatePass, gatePassdec, "assets/svg/clipboard.svg",  webBaseURL+gatePassUrl),
            const SizedBox(
              height: 5,
            ),
            lineWidget(),
            detailWidget(taskReport, taskReportdec,
                "assets/svg/clipboard.svg",  webBaseURL+taskUrl),
            lineWidget(),
            detailWidget(emphierarchy, emhierarchydec, "assets/svg/hierarchy.svg",   webBaseURL+emphierarchyUrl),
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
          launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
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

}
