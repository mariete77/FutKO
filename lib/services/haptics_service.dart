import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de vibración háptica del juego. Espeja [AudioService]: singleton,
/// estado persistido en SharedPreferences y fallo silencioso (en web y en
/// dispositivos sin motor háptico las llamadas son no-op).
class HapticsService {
  static final HapticsService _instance = HapticsService._internal();

  factory HapticsService() {
    return _instance;
  }

  HapticsService._internal();

  bool _enabled = true;

  bool get enabled => _enabled;

  /// Cargar la preferencia desde SharedPreferences.
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('haptics_enabled') ?? true;
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptics_enabled', value);
  }

  /// Click ligero al pulsar una opción.
  void tap() {
    if (!_enabled) return;
    HapticFeedback.selectionClick();
  }

  /// Acierto (gol): golpe medio.
  void success() {
    if (!_enabled) return;
    HapticFeedback.mediumImpact();
  }

  /// Fallo (tarjeta roja): golpe fuerte.
  void error() {
    if (!_enabled) return;
    HapticFeedback.heavyImpact();
  }

  /// Tic en los últimos segundos de la cuenta atrás.
  void countdownTick() {
    if (!_enabled) return;
    HapticFeedback.selectionClick();
  }
}
