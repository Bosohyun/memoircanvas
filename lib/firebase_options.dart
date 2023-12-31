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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_YKD18Xpjpj7WOQio7CtmuRqablc2T8M',
    appId: '1:80976286501:android:f4928978c54887521e80cc',
    messagingSenderId: '80976286501',
    projectId: 'memoircanvas-f3c8b',
    storageBucket: 'memoircanvas-f3c8b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDM0TWzsWLOSeLbLnoLqpJtdfAq3WpAPYg',
    appId: '1:80976286501:ios:2eb5ceab6b57d1451e80cc',
    messagingSenderId: '80976286501',
    projectId: 'memoircanvas-f3c8b',
    storageBucket: 'memoircanvas-f3c8b.appspot.com',
    androidClientId: '80976286501-ae4o70jeasuko8rn93c0ks8s81e0ln5v.apps.googleusercontent.com',
    iosClientId: '80976286501-59fbddksn0p0hs52brroo5te8p213suc.apps.googleusercontent.com',
    iosBundleId: 'com.bosohyun.memoircanvas',
  );
}
