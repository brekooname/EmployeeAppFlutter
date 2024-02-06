
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_employee_app/home/model/FirestoreDataModel.dart';

import '../Util/utility.dart';

class firestoreAppUpdateNofifier extends ChangeNotifier {
  FirestoreDataModel? fireStoreData;
  String appVersionCode ="";
  bool isEmployeeApp = false;
  Future<void> listenToLiveUpdateStream() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try {

      Utility().checkInternetConnection().then((connectionResult) {
        if (connectionResult) {
          FirebaseFirestore.instance
              .collection("Setting")
              .doc("AppConfig")
              .snapshots()
              .listen((event) {
            var jsonObj = event.data();
            var encodedJson = json.encode(jsonObj, toEncodable: Utility().myEncode);
            var jsonData = json.decode(encodedJson);
            print("tripdata========> $jsonData");
            print('Document data: ${event.data()}');
            if(jsonData!=null && jsonData.toString().isNotEmpty) {
              fireStoreData = FirestoreDataModel.fromJson(jsonData);
              appVersionCode = packageInfo.buildNumber;
            } else {
              fireStoreData = null;
              appVersionCode = "";
            }

            if(packageInfo.packageName =="shakti.shakti_employee"){
              isEmployeeApp = true;
            }else{
              isEmployeeApp = false;
            }

            notifyListeners();
          });
        }
      });

    } catch (e) {
      debugPrint("ERROR - $e");
      return null;
    }
  }
}
