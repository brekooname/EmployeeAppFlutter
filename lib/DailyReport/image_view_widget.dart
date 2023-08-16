
import 'dart:io';

import 'package:flutter/material.dart';
import '../theme/color.dart';
import '../uiwidget/robotoTextWidget.dart';

class ImageView extends StatefulWidget {
   ImageView({Key? key,required this.imagepath}) : super(key: key);
  var imagepath;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        title: const robotoTextWidget(
            textval: "Image Display",
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
      body: Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
    image: DecorationImage(
    image: FileImage(File(widget.imagepath))
    )
    )),);
  }
}