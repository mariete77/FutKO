import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handler de mensajes recibidos con la app en segundo plano o terminada.
/// Debe ser una función de nivel superior con `vm:entry-point`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // El sistema operativo muestra automáticamente el bloque `notification`.
  // Aquí solo se procesarían datos en segundo plano si hiciera falta.
}

/// Gestiona las notificaciones push (FCM): permisos, token, y visualización
/// en primer plano mediante notificaciones locales.
class MessagingService {
  MessagingService._();
  static final MessagingService instance = MessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'futko_default',
    'Notificaciones FutKO',
    description: 'Invitaciones de amigos y avisos de partida',
    importance: Importance.high,
  );

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission();

    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Mostrar notificación cuando llega con la app en primer plano.
    FirebaseMessaging.onMessage.listen(_showForeground);

    // Asociar el token FCM al usuario logueado y mantenerlo al día.
    _messaging.onTokenRefresh.listen((token) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) _saveToken(user.uid, token);
    });
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) return;
      final token = await _messaging.getToken();
      if (token != null) await _saveToken(user.uid, token);
    });
  }

  void _showForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _saveToken(String userId, String token) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set(
      {'fcmTokens': FieldValue.arrayUnion([token])},
      SetOptions(merge: true),
    );
  }
}
