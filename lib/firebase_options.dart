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
    apiKey: 'AIzaSyDdyRRqh91IzxFBtrKhT-DAhTJJeOlBdL4',
    appId: '1:715753315737:web:b6b9bd432bd53fc82d8708',
    messagingSenderId: '715753315737',
    projectId: 'ticket-b4d7b',
    authDomain: 'ticket-b4d7b.firebaseapp.com',
    storageBucket: 'ticket-b4d7b.appspot.com',
    measurementId: 'G-9SPVJPFWEH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACjrw491yXqbBIXX5BxoFf2anGhz-1pWk',
    appId: '1:715753315737:android:f217f2f475e85c122d8708',
    messagingSenderId: '715753315737',
    projectId: 'ticket-b4d7b',
    storageBucket: 'ticket-b4d7b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8CdzPEfUGNpjQPnGtx17_QR-a7lfMBGw',
    appId: '1:715753315737:ios:0bceedeeb90b11b72d8708',
    messagingSenderId: '715753315737',
    projectId: 'ticket-b4d7b',
    storageBucket: 'ticket-b4d7b.appspot.com',
    iosBundleId: 'com.example.ticket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8CdzPEfUGNpjQPnGtx17_QR-a7lfMBGw',
    appId: '1:715753315737:ios:0bceedeeb90b11b72d8708',
    messagingSenderId: '715753315737',
    projectId: 'ticket-b4d7b',
    storageBucket: 'ticket-b4d7b.appspot.com',
    iosBundleId: 'com.example.ticket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdyRRqh91IzxFBtrKhT-DAhTJJeOlBdL4',
    appId: '1:715753315737:web:e0e71cd906b95a1a2d8708',
    messagingSenderId: '715753315737',
    projectId: 'ticket-b4d7b',
    authDomain: 'ticket-b4d7b.firebaseapp.com',
    storageBucket: 'ticket-b4d7b.appspot.com',
    measurementId: 'G-QK6W2LEK7H',
  );
}
