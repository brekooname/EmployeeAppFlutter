
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../webservice/constant.dart';

class Utility {

  bool isActiveConnection = false;
   Future<bool> checkInternetConnection() async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isActiveConnection = true;
      return  Future<bool>.value(isActiveConnection);
      }
    } on SocketException catch (_) {
      isActiveConnection = false;
      return  Future<bool>.value(isActiveConnection);
    }
    return  Future<bool>.value(isActiveConnection);
  }

 void showInSnackBar({required String value,required context}) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(value),
       duration: const Duration(milliseconds: 3000),
     ),
   );
 }
  String dateConverter(String myDate, int days) {
    String date;
    DateTime convertedDate =
    DateFormat("yyyy-MM-dd").parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - days);
    final tomorrow = DateTime(now.year, now.month, now.day + days);

    final dateToCheck = convertedDate;
    final checkDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = "Today";
    } else if (checkDate == yesterday) {
      date = "Yesterday";
    } else if (checkDate == tomorrow) {
      date = "Tomorrow";
    } else {
      date = myDate;
    }
    return date;
  }

  String monthYearConverter(String myDate, int days) {
    String date;
    DateTime convertedDate =
    DateFormat("MM/dd/yyyy").parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - days);
    final tomorrow = DateTime(now.year, now.month, now.day + days);

    final dateToCheck = convertedDate;
    final checkDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = "Today";
    } else if (checkDate == yesterday) {
      date = "Yesterday";
    } else if (checkDate == tomorrow) {
      date = "Tomorrow";
    } else {
      date = myDate;
    }
    return date;
  }


  String changeDateFormate(String date) {
    var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ssZ");
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd MMM yyyy HH:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  String changeTimeFormate1(String date) {
    var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

    var outputFormat = DateFormat('HH:mm');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }
  String changeMonthFormate(String date) {
    var inputFormat = DateFormat("yyyy.MM.dd");
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  String changePlantMonthFormate(String date) {
    var inputFormat = DateFormat("MM-dd-yyyy");
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  Future<String> isUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.get(userID)!=null && sharedPreferences.get(userID).toString().isNotEmpty){
     return "true";

    }else{
      return "false";
    }
  }


  void showToast(String toast_msg) {
    Fluttertoast.showToast(
        msg: toast_msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 9);
  }

  String? calculateRevenue(String value){
    final _volume;
    final income = double.parse(value);
    _volume = income * 6;
    print(_volume);
    return _volume.toStringAsFixed(2);
  }

  SizedBox dialogueWidget(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ));
  }
  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month , 1);
  }
  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }

  DateTime findFirstDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month , 0);
  }
  DateTime findLastDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year+1, dateTime.month, 0);
  }
}