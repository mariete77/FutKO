import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'services/audio_service.dart';
import 'services/crashlytics_service.dart';
import 'services/messaging_service.dart';
import 'services/revenuecat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics no tiene soporte web y Messaging requiere config web aparte
  // (service worker + VAPID), así que solo se inician en móvil.
  if (!kIsWeb) {
    try {
      await CrashlyticsService.initialize();
      await MessagingService.instance.initialize();
    } catch (e) {
      debugPrint('Crashlytics/Messaging init failed: $e');
    }
  }

  try {
    await RevenueCatService.initialize();
  } catch (e) {
    debugPrint('RevenueCat init failed: $e');
  }

  // Música de fondo en loop. En web el autoplay puede estar bloqueado hasta la
  // primera interacción del usuario (limitación del navegador).
  try {
    await AudioService().initialize();
    await AudioService().startAmbientMusic();
  } catch (e) {
    debugPrint('Ambient music init failed: $e');
  }

  runApp(
    const ProviderScope(
      child: FutKOBattleApp(),
    ),
  );
}
