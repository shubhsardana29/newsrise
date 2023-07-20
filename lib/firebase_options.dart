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
    apiKey: 'AIzaSyBUd7bxjxvD-OIzbU83Crk7aTQSycZcgNU',
    appId: '1:806949591441:web:de64453e4fbbacb5e82230',
    messagingSenderId: '806949591441',
    projectId: 'newsrise-73f69',
    authDomain: 'newsrise-73f69.firebaseapp.com',
    storageBucket: 'newsrise-73f69.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1s9Oy3jC_nnUu8TCun_XLjB0ThXVQb-Q',
    appId: '1:806949591441:android:c529074add2f2b4ae82230',
    messagingSenderId: '806949591441',
    projectId: 'newsrise-73f69',
    storageBucket: 'newsrise-73f69.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZXuFtUD2VWdweDmjPPB5QStXzRVXqEIQ',
    appId: '1:806949591441:ios:f24ae9784037b978e82230',
    messagingSenderId: '806949591441',
    projectId: 'newsrise-73f69',
    storageBucket: 'newsrise-73f69.appspot.com',
    iosClientId: '806949591441-qf03lqe6etfmosee3etrget11h2k8afs.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsrise',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZXuFtUD2VWdweDmjPPB5QStXzRVXqEIQ',
    appId: '1:806949591441:ios:f24ae9784037b978e82230',
    messagingSenderId: '806949591441',
    projectId: 'newsrise-73f69',
    storageBucket: 'newsrise-73f69.appspot.com',
    iosClientId: '806949591441-qf03lqe6etfmosee3etrget11h2k8afs.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsrise',
  );
}
