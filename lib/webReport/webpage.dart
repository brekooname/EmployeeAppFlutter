import 'package:flutter/material.dart';
import 'package:shakti_employee_app/theme/color.dart';
import 'package:shakti_employee_app/uiwidget/robotoTextWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
   WebPage({Key? key,required this.title,required this.url}) : super(key: key);
  String title,url;

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _controller;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = true;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: robotoTextWidget(textval: widget.title,
          colorval: Colors.white, sizeval: 14, fontWeight: FontWeight.w600)),
      body: isLoading? const Center(child: SizedBox(height: 30,
      width: 30,child: CircularProgressIndicator(
          color: AppColor.themeColor,
        ),),):WebViewWidget(controller: _controller),
    );
  }
}
