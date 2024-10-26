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
    apiKey: 'AIzaSyC5d78OBUHVFSGUSaN2JPIxCPBzRx4JToo',
    appId: '1:445034227426:web:dbc84aedeb08c93cdca0bb',
    messagingSenderId: '445034227426',
    projectId: 'advanced-chat-app-3948f',
    authDomain: 'advanced-chat-app-3948f.firebaseapp.com',
    storageBucket: 'advanced-chat-app-3948f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFlvmF3CsMPpOTG1qUh6jsyBWDlocdXGA',
    appId: '1:445034227426:android:006c8c076d4c0b7edca0bb',
    messagingSenderId: '445034227426',
    projectId: 'advanced-chat-app-3948f',
    storageBucket: 'advanced-chat-app-3948f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCt_FumeutTgopTOT2zVY9zXUeJwbpkvSk',
    appId: '1:445034227426:ios:641412f1c9cada3cdca0bb',
    messagingSenderId: '445034227426',
    projectId: 'advanced-chat-app-3948f',
    storageBucket: 'advanced-chat-app-3948f.appspot.com',
    iosBundleId: 'com.example.advancedChatApp',
  );
}