//  import 'dart:async';
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//  import 'package:timezone/data/latest_all.dart' as tz;
//
// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
//
//   static StreamController<NotificationResponse> streamController = StreamController();
//
//   static onTap(NotificationResponse notificationResponse){
//     streamController.add(notificationResponse);
//   }
//
//   static Future<void> initialize() async {
//      InitializationSettings initializationSettings = const InitializationSettings(
//     android : AndroidInitializationSettings('@mipmap/ic_launcher'),
//
//      );
//
//     await _notifications.initialize(initializationSettings);
//     tz.initializeTimeZones();
//   }
//
//   static Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'doctorApp_channel',
//       'doctorApp Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await _notifications.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }
// }