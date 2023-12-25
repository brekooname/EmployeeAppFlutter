import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shakti_employee_app/theme/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/utility.dart';
import '../database/database_helper.dart';
import '../home/model/WayPointsModel.dart';
import '../home/model/local_convence_model.dart';
import '../webservice/constant.dart';

class BackgroundLocationService extends ChangeNotifier {
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String wayPoint ="";
  LatLng? latlong;
  late SharedPreferences sharedPreferences;
  List<WayPointsModel> wayPointList = [];
  List<LocalConveyanceModel> localConveyanceList = [];
  Timer? timer;
  var MeterDistance = 30;
  bool _serviceEnabled = false;


  BackgroundLocationService() {
    log('Creating Singleton of BackgroundLocationServiceSingleton');
  }

  Future<void> startLocationFetch() async {
    sharedPreferences = await SharedPreferences.getInstance();

    Location location = new Location();
    var _permissionGranted = await location.hasPermission();
    _serviceEnabled = await location.serviceEnabled();
    if (_permissionGranted != PermissionStatus.granted || !_serviceEnabled) {
      _permissionGranted = await location.requestPermission();
      _serviceEnabled = await location.requestService();
    } else {
      location.enableBackgroundMode(enable: true);
      location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        if(currentLocation!=null && currentLocation.toString().isNotEmpty) {

          if(sharedPreferences.getString(localConveyanceJourneyStart)==True) {
            latitude = currentLocation.latitude.toString();
            longitude = currentLocation.longitude.toString();

            getLatLng();
          }
        }
      });
    }
   // timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getLatLng());


  }

  void stopLocationFetch() {
    timer?.cancel();
    notifyListeners();
  }

  getLatLng() async {
    print("MethodStart=====>true");
    print('''\n    Latitude:  $latitude  Longitude: $longitude    ''');
    print('''\n    Latitude222:  ${sharedPreferences.getString(FromLatitude)}  Longitude2222: ${sharedPreferences.getString(FromLongitude)}    ''');

    if(sharedPreferences.getString(FromLatitude)!=null && !sharedPreferences.getString(FromLatitude).toString().isEmpty
        && sharedPreferences.getString(FromLatitude)!=latitude) {

      print('calculateDistance========>${Utility().calculateDistance(double.parse(sharedPreferences.getString(FromLatitude).toString()),
          double.parse(sharedPreferences.getString(FromLongitude).toString()),double.parse(latitude),double.parse(longitude))}');

      var calculateDistance = Utility().calculateDistance(double.parse(sharedPreferences.getString(FromLatitude).toString()),
          double.parse(sharedPreferences.getString(FromLongitude).toString()),double.parse(latitude),double.parse(longitude));

     if(calculateDistance>MeterDistance){
      List<Map<String, dynamic>> listMap =
      await DatabaseHelper.instance.queryAllLocalConveyance();
        listMap.forEach(
                (map) => localConveyanceList.add(LocalConveyanceModel.fromMap(map)));
        if (localConveyanceList.isNotEmpty) {
          List<Map<String, dynamic>> listMap =
          await DatabaseHelper.instance.queryAllWaypoints(
              localConveyanceList[localConveyanceList.length - 1]
                  .toMapWithoutId());

          listMap.forEach(
                  (map) => wayPointList.add(WayPointsModel.fromMap(map)));

          for (var j = 0; j < wayPointList.length; j++) {

            wayPoint = wayPointList[j].latlng + "|" + "via:" + latitude + "," +
                longitude;
          }

          print('wayPoint=======>$wayPoint');
          if(!wayPointList.contains(wayPoint)) {
            WayPointsModel waypoints = WayPointsModel(
                userId: sharedPreferences.getString(userID).toString(),
                latlng: wayPoint,
                createDate: wayPointList[wayPointList.length - 1].createDate,
                createTime: wayPointList[wayPointList.length - 1].createTime,
                endDate: '',
                endTime: '');
            DatabaseHelper.instance.updateWaypoints(waypoints.toMapWithoutId());
            Utility().setSharedPreference(
                FromLatitude, latitude);
            Utility().setSharedPreference(
                FromLongitude, longitude);
            print('DatabseUpdate=======>true');

            notifyListeners();
          }
        }
        }
    }
  }
}

