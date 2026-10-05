import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 17 & 18 - Firebase Options Configuration
/// LOGIC  : Contains generated API keys and project IDs for craftculture-platform.
/// VIVA TIP: Why use FirebaseOptions instead of hardcoded strings in main()?
///          - FirebaseOptions encapsulates cross-platform credentials (Web, Android, iOS).
/// ============================================================================

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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDXEfrj2tSbW4sRf6zg-nkBxyIzb37iKng',
    appId: '1:52527882144:web:f1f83ea98c3577cbf94ec5',
    messagingSenderId: '52527882144',
    projectId: 'craftculture-platform',
    authDomain: 'craftculture-platform.firebaseapp.com',
    storageBucket: 'craftculture-platform.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXEfrj2tSbW4sRf6zg-nkBxyIzb37iKng',
    appId: '1:52527882144:web:f1f83ea98c3577cbf94ec5',
    messagingSenderId: '52527882144',
    projectId: 'craftculture-platform',
    storageBucket: 'craftculture-platform.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXEfrj2tSbW4sRf6zg-nkBxyIzb37iKng',
    appId: '1:52527882144:web:f1f83ea98c3577cbf94ec5',
    messagingSenderId: '52527882144',
    projectId: 'craftculture-platform',
    storageBucket: 'craftculture-platform.firebasestorage.app',
    iosBundleId: 'com.example.craftCultureApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXEfrj2tSbW4sRf6zg-nkBxyIzb37iKng',
    appId: '1:52527882144:web:f1f83ea98c3577cbf94ec5',
    messagingSenderId: '52527882144',
    projectId: 'craftculture-platform',
    storageBucket: 'craftculture-platform.firebasestorage.app',
    iosBundleId: 'com.example.craftCultureApp',
  );
}
