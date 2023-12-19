import 'dart:developer';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BackgroundLocationService extends ChangeNotifier {
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';
  String address = 'waiting...';
  LatLng? latlong;
  BackgroundLocationService() {
    log('Creating Singleton of BackgroundLocationService');
  }
  var _count = 0;
  int get count => _count;
  Future<void> startLocationFetch() async {
    print('startLocationFetch=====>true');
    await BackgroundLocation.setAndroidNotification(
      title: 'Background service is running',
      message: 'Background location in progress',
      icon: '@mipmap/ic_launcher',
    );
    //await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService(
        distanceFilter: 20);
    BackgroundLocation.getLocationUpdates((location) async {

        latitude = location.latitude.toString();
        longitude = location.longitude.toString();
        accuracy = location.accuracy.toString();
        altitude = location.altitude.toString();
        bearing = location.bearing.toString();
        speed = location.speed.toString();
        time = DateTime.fromMillisecondsSinceEpoch(
            location.time!.toInt())
            .toString();

      print('''\n
                        Latitude:  $latitude
                        Longitude: $longitude
                        Altitude: $altitude
                        Accuracy: $accuracy
                        Bearing:  $bearing
                        Speed: $speed
                        Time: $time
                      ''');

        latlong = LatLng(location.latitude!.toDouble(), location.longitude!.toDouble());
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude!.toDouble(), location.longitude!.toDouble(),
            localeIdentifier: 'en');
        Placemark place = placemarks[0];
        address =
        '${place.street},  ${place.subAdministrativeArea},  ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';

        print('address====>$address');
    });

    notifyListeners();
  }

  void stopLocationFetch() {
    BackgroundLocation.stopLocationService();
    notifyListeners();
  }
}
