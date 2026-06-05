import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Captura los errores no controlados de Flutter y de la plataforma y los
/// envía a Firebase Crashlytics.
///
/// La recolección se desactiva en modo debug; cambia [_collectInDebug] a `true`
/// si quieres probar el reporte en local.
class CrashlyticsService {
  CrashlyticsService._();

  static const bool _collectInDebug = false;

  static Future<void> initialize() async {
    final crashlytics = FirebaseCrashlytics.instance;

    await crashlytics.setCrashlyticsCollectionEnabled(
      _collectInDebug || !kDebugMode,
    );

    // Errores del framework Flutter (build/layout/paint).
    FlutterError.onError = crashlytics.recordFlutterFatalError;

    // Errores asíncronos que escapan del árbol de widgets.
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
