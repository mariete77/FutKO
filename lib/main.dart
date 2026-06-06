import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'services/crashlytics_service.dart';
import 'services/messaging_service.dart';
import 'services/revenuecat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CrashlyticsService.initialize();
  await MessagingService.instance.initialize();

  try {
    await RevenueCatService.initialize();
  } catch (e) {
    debugPrint('RevenueCat init failed: $e');
  }

  runApp(
    const ProviderScope(
      child: FutKOBattleApp(),
    ),
  );
}
