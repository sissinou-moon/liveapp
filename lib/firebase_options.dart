// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCbS2E2azb5EHof8SYg_-B_-ITOePUSMgs',
    appId: '1:594871234652:web:d0e8132b8a35608b23f699',
    messagingSenderId: '594871234652',
    projectId: 'livepulp-cfa77',
    authDomain: 'livepulp-cfa77.firebaseapp.com',
    databaseURL: 'https://livepulp-cfa77-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'livepulp-cfa77.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkXQU93R0cArqWZ1UBDuquSA2rjB2dgWg',
    appId: '1:594871234652:android:fccc1ae4137ac87c23f699',
    messagingSenderId: '594871234652',
    projectId: 'livepulp-cfa77',
    databaseURL: 'https://livepulp-cfa77-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'livepulp-cfa77.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBL-5wJhLm2fRnymNr9j1ciVdSUwFD6Ecs',
    appId: '1:594871234652:ios:2bb564bcaaf15f0723f699',
    messagingSenderId: '594871234652',
    projectId: 'livepulp-cfa77',
    databaseURL: 'https://livepulp-cfa77-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'livepulp-cfa77.firebasestorage.app',
    iosBundleId: 'com.example.launcher',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBL-5wJhLm2fRnymNr9j1ciVdSUwFD6Ecs',
    appId: '1:594871234652:ios:2bb564bcaaf15f0723f699',
    messagingSenderId: '594871234652',
    projectId: 'livepulp-cfa77',
    databaseURL: 'https://livepulp-cfa77-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'livepulp-cfa77.firebasestorage.app',
    iosBundleId: 'com.example.launcher',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCbS2E2azb5EHof8SYg_-B_-ITOePUSMgs',
    appId: '1:594871234652:web:7bcf86dd429ed14823f699',
    messagingSenderId: '594871234652',
    projectId: 'livepulp-cfa77',
    authDomain: 'livepulp-cfa77.firebaseapp.com',
    databaseURL: 'https://livepulp-cfa77-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'livepulp-cfa77.firebasestorage.app',
  );

}