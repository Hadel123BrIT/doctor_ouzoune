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
      // طلب الأذونات
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      log('Notification permission: ${settings.authorizationStatus}');

      // الحصول على token وإرساله
      String? token = await messaging.getToken();
      if (token != null) {
        sendTokenToServer(token);
        log('Device Token: $token');

        // حفظ Token في التخزين المحلي
        final box = GetStorage();
        await box.write('device_token', token);
      }

      // الاستماع لتحديث Token
      messaging.onTokenRefresh.listen(sendTokenToServer);

      // الاشتراك في Topic
      await messaging.subscribeToTopic('all');
      log('Subscribed to topic: all');

      // معالجة الإشعارات في الخلفية
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // معالجة الإشعارات في الواجهة
      handleForegroundMessage();

      // معالجة الإشعارات عند النقر عليها
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
    // أضف هنا كود إرسال Token إلى السيرفر
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