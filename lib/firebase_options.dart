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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC3WJXkloCoakSJ_9fFKeKJ3bYKp9WzgBI',
    appId: '1:198819102898:web:43a761595d328a4171c9ab',
    messagingSenderId: '198819102898',
    projectId: 'fir-test-8c1d4',
    authDomain: 'fir-test-8c1d4.firebaseapp.com',
    storageBucket: 'fir-test-8c1d4.appspot.com',
    measurementId: 'G-58976D7T88',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_y3GKszQAQVX3c7lpOxBbh72CkR2emJY',
    appId: '1:198819102898:android:081c032ace3bff9471c9ab',
    messagingSenderId: '198819102898',
    projectId: 'fir-test-8c1d4',
    storageBucket: 'fir-test-8c1d4.appspot.com',
  );
}
