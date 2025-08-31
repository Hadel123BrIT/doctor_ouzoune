import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'LocalNotificationService .dart';

class FirebaseServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    try {

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      log('Notification permission: ${settings.authorizationStatus}');

      String? token = await messaging.getToken();
      if (token != null) {
        sendTokenToServer(token);
        log('Device Token: $token');

        final box = GetStorage();
        await box.write('device_token', token);
      }


      messaging.onTokenRefresh.listen(sendTokenToServer);


      await messaging.subscribeToTopic('all');
      log('Subscribed to topic: all');


      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      handleForegroundMessage();

      handleNotificationOpenedApp();

    } catch (e) {
      log('Error initializing Firebase: $e');
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Background Message: ${message.notification?.title}');


    LocalNotificationService.showBasicNotification(message);
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground Message: ${message.notification?.title}');


      LocalNotificationService.showBasicNotification(message);
    });
  }

  static void handleNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification tapped: ${message.notification?.title}');

    });
  }

  static void sendTokenToServer(String token) {
    log('Sending token to server: $token');
  }

  static Future<void> deleteToken() async {
    try {
      await messaging.deleteToken();
      final box = GetStorage();
      await box.remove('device_token');
      log('Device token deleted');
    } catch (e) {
      log('Error deleting token: $e');
    }
  }
}