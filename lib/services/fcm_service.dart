import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  // Inisialisasi Firebase Cloud Messaging
  static Future<void> initialize(BuildContext context) async {
    // Request permission
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      debugPrint('Notifikasi diizinkan');
    } else {
      debugPrint('Notifikasi ditolak');
    }

    // Ambil token FCM
    String? token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // Saat aplikasi sedang dibuka (foreground)
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {
          _showSnackBar(
            context,
            message.notification!.title ?? 'Notifikasi',
            message.notification!.body ?? '',
          );
        }
      },
    );

    // Saat notifikasi ditekan
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint(
          'Notifikasi dibuka: ${message.data}',
        );
      },
    );
  }

  // Snackbar notifikasi
  static void _showSnackBar(
    BuildContext context,
    String title,
    String body,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    body,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A6BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Notifikasi saat event berhasil dibuat
  static Future<void> sendEventNotification(
    BuildContext context,
    String eventTitle,
  ) async {
    _showSnackBar(
      context,
      'Event Baru Dibuat!',
      'Event "$eventTitle" telah berhasil ditambahkan.',
    );
  }
}