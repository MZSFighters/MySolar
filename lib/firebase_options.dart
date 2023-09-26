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
    apiKey: 'AIzaSyBmPwbtqEVJyYB0Lpsfj6soG5Vi-ohficA',
    appId: '1:878845743646:web:d95ee7530329012546140f',
    messagingSenderId: '878845743646',
    projectId: 'mysolar-72ca5',
    authDomain: 'mysolar-72ca5.firebaseapp.com',
    databaseURL: 'https://mysolar-72ca5-default-rtdb.firebaseio.com',
    storageBucket: 'mysolar-72ca5.appspot.com',
    measurementId: 'G-0CYEQ3MZ29',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB48FkizzKstPPE4de64JQ5xxG4pyoHWXY',
    appId: '1:878845743646:android:4cd21ecf88ac9d9246140f',
    messagingSenderId: '878845743646',
    projectId: 'mysolar-72ca5',
    databaseURL: 'https://mysolar-72ca5-default-rtdb.firebaseio.com',
    storageBucket: 'mysolar-72ca5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbsRQnIO50MA9MonSXdxSaDoNLDOnLXF4',
    appId: '1:878845743646:ios:6347fc0205b9a68a46140f',
    messagingSenderId: '878845743646',
    projectId: 'mysolar-72ca5',
    databaseURL: 'https://mysolar-72ca5-default-rtdb.firebaseio.com',
    storageBucket: 'mysolar-72ca5.appspot.com',
    androidClientId: '878845743646-pr7ir1um9ge6kkflphjv79j6ndg1c8e8.apps.googleusercontent.com',
    iosClientId: '878845743646-e0d9btpqrjksebrtf06rnahjn2hu26tv.apps.googleusercontent.com',
    iosBundleId: 'com.example.deviceScheduler',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbsRQnIO50MA9MonSXdxSaDoNLDOnLXF4',
    appId: '1:878845743646:ios:2b6be5d86753fb8b46140f',
    messagingSenderId: '878845743646',
    projectId: 'mysolar-72ca5',
    databaseURL: 'https://mysolar-72ca5-default-rtdb.firebaseio.com',
    storageBucket: 'mysolar-72ca5.appspot.com',
    androidClientId: '878845743646-pr7ir1um9ge6kkflphjv79j6ndg1c8e8.apps.googleusercontent.com',
    iosClientId: '878845743646-4jqktbchg0isl3sppi8qg81i4resbhep.apps.googleusercontent.com',
    iosBundleId: 'com.example.deviceScheduler.RunnerTests',
  );
}
