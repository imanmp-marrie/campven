import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    // Setup local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);

    // Buat notification channel Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'campven_channel',
      'Campven Notifications',
      description: 'Notifikasi event kampus dari Campven',
      importance: Importance.high,
    );
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // Minta izin notifikasi
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notifikasi diizinkan');
    }

    // Ambil FCM Token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handler notifikasi saat app di FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Tampilkan notifikasi HP langsung
        _showLocalNotification(
          message.notification!.title ?? 'Notifikasi Baru',
          message.notification!.body ?? '',
        );
        // Tampilkan snackbar juga
        if (context.mounted) {
          _showSnackBar(
            context,
            message.notification!.title ?? 'Notifikasi Baru',
            message.notification!.body ?? '',
          );
        }
      }
    });

    // Handler saat notifikasi di-tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notifikasi di-tap: ${message.data}');
    });
  }

  // Tampilkan notifikasi HP langsung
  static Future<void> _showLocalNotification(
      String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'campven_channel',
      'Campven Notifications',
      channelDescription: 'Notifikasi event kampus dari Campven',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  // Tampilkan snackbar
  static void _showSnackBar(
      BuildContext context, String title, String body) {
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(body,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A6BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Kirim notifikasi saat event baru dibuat
  static Future<void> sendEventNotification(
      BuildContext context, String eventTitle) async {
    // Tampilkan notifikasi HP langsung
    await _showLocalNotification(
      '🎉 Event Baru Dibuat!',
      'Event "$eventTitle" telah berhasil ditambahkan ke Campven.',
    );
    // Tampilkan snackbar juga
    if (context.mounted) {
      _showSnackBar(
        context,
        'Event Baru Dibuat!',
        'Event "$eventTitle" telah berhasil ditambahkan.',
      );
    }
  }
}