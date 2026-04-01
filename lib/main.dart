import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/services/seed_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Firebase init — if it fails, still launch app
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Hive local storage
  try {
    await Hive.initFlutter();
  } catch (e) {
    debugPrint('Hive init error: $e');
  }

  // Launch app IMMEDIATELY — don't block on seeding
  runApp(const ProviderScope(child: AciDioceseApp()));

  // Seed data in background AFTER app is running
  SeedService.seedIfNeeded();
}
