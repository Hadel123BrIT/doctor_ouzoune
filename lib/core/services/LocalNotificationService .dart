import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
  StreamController();

  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );


    await createNotificationChannel();
  }


  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'Channel for Doctor App notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    try {

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'Channel for Doctor App notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,

      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? 'You have a new message',
        details,
        payload: json.encode(message.data),
      );

      log('Notification shown successfully');

    } catch (e) {
      log('Error showing notification: $e');
    }
  }
}