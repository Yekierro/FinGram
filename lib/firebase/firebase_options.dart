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
    apiKey: 'AIzaSyDxtW5DrdamN5R3-d_2LhpabCra8AT6hZw',
    appId: '1:648636581940:web:0c55b18653c96d2bc26261',
    messagingSenderId: '648636581940',
    projectId: 'fingram-29a43',
    authDomain: 'fingram-29a43.firebaseapp.com',
    storageBucket: 'fingram-29a43.appspot.com',
    measurementId: 'G-2H3TWHRDQZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsXE81BQFyXjYUM8E4EXvU0zaA98RNjKo',
    appId: '1:648636581940:android:bb18e1b820799c96c26261',
    messagingSenderId: '648636581940',
    projectId: 'fingram-29a43',
    storageBucket: 'fingram-29a43.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXczxy5FnaYV1cs_36cifaM47BqJi_Nq4',
    appId: '1:648636581940:ios:45c03d5f968f1634c26261',
    messagingSenderId: '648636581940',
    projectId: 'fingram-29a43',
    storageBucket: 'fingram-29a43.appspot.com',
    iosBundleId: 'com.example.fingram',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXczxy5FnaYV1cs_36cifaM47BqJi_Nq4',
    appId: '1:648636581940:ios:45c03d5f968f1634c26261',
    messagingSenderId: '648636581940',
    projectId: 'fingram-29a43',
    storageBucket: 'fingram-29a43.appspot.com',
    iosBundleId: 'com.example.fingram',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDxtW5DrdamN5R3-d_2LhpabCra8AT6hZw',
    appId: '1:648636581940:web:c673ee6acf675750c26261',
    messagingSenderId: '648636581940',
    projectId: 'fingram-29a43',
    authDomain: 'fingram-29a43.firebaseapp.com',
    storageBucket: 'fingram-29a43.appspot.com',
    measurementId: 'G-KBKR9440MT',
  );
}
