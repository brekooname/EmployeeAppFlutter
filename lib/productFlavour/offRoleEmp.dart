import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../firebase_options.dart';
import '../main.dart';
import '../notificationService/local_notification_service.dart';
import '../theme/string.dart';
import 'applicationconfig.dart';

void main() async {

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        name: appName2,
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    LocalNotificationService.initialize();
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    ApplicationConfig devAppConfig = ApplicationConfig(appName: 'OffRole Employee', flavor: 'offrole_emp');
    Widget app = await initializeApp(devAppConfig);
    runApp(app);

  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));


}