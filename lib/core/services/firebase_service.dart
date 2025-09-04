import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../views/notification/notification_controller/notification_controller.dart';
import 'LocalNotificationService .dart';

class FirebaseServices extends GetxService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
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
        _sendTokenToServer(token);
        log('Device Token: $token');

        final box = GetStorage();
        await box.write('device_token', token);
      }

      messaging.onTokenRefresh.listen(_sendTokenToServer);

      await messaging.subscribeToTopic('all');
      log('Subscribed to topic: all');

      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      _handleForegroundMessage();
      _handleNotificationOpenedApp();

    } catch (e) {
      log('Error initializing Firebase: $e');
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Background Message: ${message.notification?.title}');

    if (Get.isRegistered<LocalNotificationService>()) {
      Get.find<LocalNotificationService>().showBasicNotification(message);
    }

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().refreshNotifications();
    }
  }

  void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground Message: ${message.notification?.title}');

      if (Get.isRegistered<LocalNotificationService>()) {
        Get.find<LocalNotificationService>().showBasicNotification(message);
      }

      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().refreshNotifications();
      }
    });
  }

  void _handleNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification tapped: ${message.notification?.title}');

      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().refreshNotifications();
      }
    });
  }

  void _sendTokenToServer(String token) {
    log('Sending token to server: $token');
  }

  Future<void> deleteToken() async {
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