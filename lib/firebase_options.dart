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
    apiKey: 'AIzaSyA3VULQJnsMGsQpDSAoxxiQK2K0_ecLBtE',
    appId: '1:448059775465:web:f21f1ad9c46cf752c19378',
    messagingSenderId: '448059775465',
    projectId: 'idonatelife-clean-archit-dcc7e',
    authDomain: 'idonatelife-clean-archit-dcc7e.firebaseapp.com',
    storageBucket: 'idonatelife-clean-archit-dcc7e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJLAuMAsmu1vwAKM5tTPzeBKr_udMmn_I',
    appId: '1:448059775465:android:df8809db5aad0e27c19378',
    messagingSenderId: '448059775465',
    projectId: 'idonatelife-clean-archit-dcc7e',
    storageBucket: 'idonatelife-clean-archit-dcc7e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARunRBoKSKhrpZusvH-ZOjzm_YSGkBmjA',
    appId: '1:448059775465:ios:3a94cf597be73682c19378',
    messagingSenderId: '448059775465',
    projectId: 'idonatelife-clean-archit-dcc7e',
    storageBucket: 'idonatelife-clean-archit-dcc7e.appspot.com',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARunRBoKSKhrpZusvH-ZOjzm_YSGkBmjA',
    appId: '1:448059775465:ios:52cae266dd0fd178c19378',
    messagingSenderId: '448059775465',
    projectId: 'idonatelife-clean-archit-dcc7e',
    storageBucket: 'idonatelife-clean-archit-dcc7e.appspot.com',
    iosBundleId: 'com.example.myapp.RunnerTests',
  );
}