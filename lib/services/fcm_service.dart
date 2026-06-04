import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Inisialisasi FCM
  static Future<void> initialize(BuildContext context) async {
    // Minta izin notifikasi
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notifikasi diizinkan');
    }

    // Ambil FCM token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handler notifikasi saat app di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showSnackBar(context, message.notification!.title ?? 'Notifikasi',
            message.notification!.body ?? '');
      }
    });

    // Handler saat notifikasi di-tap (app di background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notifikasi di-tap: ${message.data}');
    });
  }

  // Tampilkan snackbar saat dapat notifikasi foreground
  static void _showSnackBar(BuildContext context, String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(body,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A6BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Kirim notifikasi lokal saat event baru dibuat
  static Future<void> sendEventNotification(String eventTitle) async {
    print('Event baru dibuat: $eventTitle');
  }
}