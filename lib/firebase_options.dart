import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS platform is not configured.');
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABpYhD1K5II--vyclXyrHzYY8ph2YVezk',
    appId: '1:714322690479:android:59963df59d9e8d12886f5a',
    messagingSenderId: '714322690479',
    projectId: 'selvin-e3723',
    storageBucket: 'selvin-e3723.firebasestorage.app',
  );
}
