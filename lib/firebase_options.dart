// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAWVHehcY4K4f53KOCw5QaSojC1zTBbdq8',
    appId: '1:670091446020:web:3132db6296fd70e057b251',
    messagingSenderId: '670091446020',
    projectId: 'shaktiemployeeapp',
    authDomain: 'shaktiemployeeapp.firebaseapp.com',
    storageBucket: 'shaktiemployeeapp.appspot.com',
    measurementId: 'G-Y1QJF9Y1Q1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8sG_O8omWeHcpK6GvJb_pmyltoigA2zU',
    appId: '1:670091446020:android:b89d0c1d720b0c2c57b251',
    messagingSenderId: '670091446020',
    projectId: 'shaktiemployeeapp',
    storageBucket: 'shaktiemployeeapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7ZZTAciGVEyerzvfWlJ8n677jmYUwiu0',
    appId: '1:670091446020:ios:81f277c96e0e00c857b251',
    messagingSenderId: '670091446020',
    projectId: 'shaktiemployeeapp',
    storageBucket: 'shaktiemployeeapp.appspot.com',
    androidClientId: '670091446020-1r9r77op1f3nfplipnb4fu3hbn553t32.apps.googleusercontent.com',
    iosBundleId: 'com.example.shaktiEmployeeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7ZZTAciGVEyerzvfWlJ8n677jmYUwiu0',
    appId: '1:670091446020:ios:968723302c21a57d57b251',
    messagingSenderId: '670091446020',
    projectId: 'shaktiemployeeapp',
    storageBucket: 'shaktiemployeeapp.appspot.com',
    androidClientId: '670091446020-1r9r77op1f3nfplipnb4fu3hbn553t32.apps.googleusercontent.com',
    iosBundleId: 'com.example.shaktiEmployeeApp.RunnerTests',
  );
}
