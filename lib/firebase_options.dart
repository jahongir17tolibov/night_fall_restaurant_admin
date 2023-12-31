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
    apiKey: 'AIzaSyD4UQoRVCekJqQmCoZ-R8WUA95vhtHs2Q0',
    appId: '1:1025632038015:web:f9533dc6b21c145841234a',
    messagingSenderId: '1025632038015',
    projectId: 'night-fall-restaurant',
    authDomain: 'night-fall-restaurant.firebaseapp.com',
    storageBucket: 'night-fall-restaurant.appspot.com',
    measurementId: 'G-J16G1VHWP7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDR45Dco6P_LqE7YYx1vTlu_KDVMSqwXgo',
    appId: '1:1025632038015:android:65e4ced50612e65941234a',
    messagingSenderId: '1025632038015',
    projectId: 'night-fall-restaurant',
    storageBucket: 'night-fall-restaurant.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgpPil79TzGmGtpXXHYu0_DnR4B3cylHM',
    appId: '1:1025632038015:ios:729718b732a3687641234a',
    messagingSenderId: '1025632038015',
    projectId: 'night-fall-restaurant',
    storageBucket: 'night-fall-restaurant.appspot.com',
    iosBundleId: 'com.example.nightFallRestaurantAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgpPil79TzGmGtpXXHYu0_DnR4B3cylHM',
    appId: '1:1025632038015:ios:2b3f52da2c8c7e4141234a',
    messagingSenderId: '1025632038015',
    projectId: 'night-fall-restaurant',
    storageBucket: 'night-fall-restaurant.appspot.com',
    iosBundleId: 'com.example.nightFallRestaurantAdmin.RunnerTests',
  );
}
