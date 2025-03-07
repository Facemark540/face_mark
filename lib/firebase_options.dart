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
    apiKey: 'AIzaSyCZGmk7jwsU5Sf7Pz3-DOPuL5Hp4XfpwKM',
    appId: '1:690264837267:web:0d1d69c436501930691166',
    messagingSenderId: '690264837267',
    projectId: 'face-mark-4c60c',
    authDomain: 'face-mark-4c60c.firebaseapp.com',
    storageBucket: 'face-mark-4c60c.firebasestorage.app',
    measurementId: 'G-64Z9PK2TLH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZ4mmmgi7gAdAk1ZGtMQnMM3iy0mK30DA',
    appId: '1:690264837267:android:1a82cef5fc9e3e75691166',
    messagingSenderId: '690264837267',
    projectId: 'face-mark-4c60c',
    storageBucket: 'face-mark-4c60c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDb2-OF2i6--5hQbMD1TkeDIR81JTJy9T8',
    appId: '1:690264837267:ios:a84f7c185486fdb7691166',
    messagingSenderId: '690264837267',
    projectId: 'face-mark-4c60c',
    storageBucket: 'face-mark-4c60c.firebasestorage.app',
    iosBundleId: 'com.example.faceMark',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDb2-OF2i6--5hQbMD1TkeDIR81JTJy9T8',
    appId: '1:690264837267:ios:a84f7c185486fdb7691166',
    messagingSenderId: '690264837267',
    projectId: 'face-mark-4c60c',
    storageBucket: 'face-mark-4c60c.firebasestorage.app',
    iosBundleId: 'com.example.faceMark',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCZGmk7jwsU5Sf7Pz3-DOPuL5Hp4XfpwKM',
    appId: '1:690264837267:web:b2aceb746ab0fbd2691166',
    messagingSenderId: '690264837267',
    projectId: 'face-mark-4c60c',
    authDomain: 'face-mark-4c60c.firebaseapp.com',
    storageBucket: 'face-mark-4c60c.firebasestorage.app',
    measurementId: 'G-XY9030HE5H',
  );
}
