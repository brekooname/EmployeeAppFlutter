
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shakti_employee_app/home/model/ScyncAndroidtoSAP.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../gatepass/model/PendingGatePassResponse.dart';
import '../home/model/personalindoresponse.dart';
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



  void showToast(String toast_msg) {
    Fluttertoast.showToast(
        msg: toast_msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 9);
  }




  setSharedPreference(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  clearSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  void saveArrayList(List<String> list, int position) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch (position) {
      case 0:
        preferences.setStringList(leaveBalanceLists, list);
        break;
      case 1:
        preferences.setStringList(activeEmployeeLists, list);
        break;
      case 2:
        preferences.setStringList(attendenceLists, list);
        break;
      case 3:
        preferences.setStringList(odEmpLists, list);
        break;
      case 4:
        preferences.setStringList(leaveEmpLists, list);
        break;
      case 5:
        preferences.setStringList(pendingTaskLists, list);
        break;
      case 6:
        preferences.setStringList(pendingLeaveLists, list);
        break;
      case 7:
        preferences.setStringList(pendindOdLists, list);
        break;
      case 8:
        preferences.setStringList(personalInfos, list);
        break;
      case 9:
        preferences.setStringList(gatePassLists, list);
        break;
    }
  }


}