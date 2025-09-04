import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../views/notification/notification_controller/notification_controller.dart';

class LocalNotificationService extends GetxService {
  static LocalNotificationService? _instance;

  static LocalNotificationService get instance {
    if (_instance == null) {
      _instance = Get.put(LocalNotificationService());
    }
    return _instance!;
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late StreamController<NotificationResponse> streamController;

  final RxBool hasNewNotification = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    streamController = StreamController<NotificationResponse>.broadcast();

    await _initializeNotifications();
    setupNotificationHandlers();
    log('LocalNotificationService initialized');
  }

  Future<void> _initializeNotifications() async {
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
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );

    await _createNotificationChannel();
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
    hasNewNotification.value = true;
    _handleNotificationTap(notificationResponse);
  }

  Future<void> _createNotificationChannel() async {
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

  void setupNotificationHandlers() {
    streamController.stream.listen((NotificationResponse response) {
      _handleNotificationTap(response);
    });
  }

  void _handleNotificationTap(NotificationResponse response) {
    try {
      final payload = response.payload;
      if (payload != null) {
        final data = json.decode(payload);
        log('Notification tapped with data: $data');
        _triggerNotificationRefresh();
      }
    } catch (e) {
      log('Error handling notification tap: $e');
    }
  }

  void _triggerNotificationRefresh() {
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().refreshNotifications();
    }
  }

  Future<void> showBasicNotification(RemoteMessage message) async {
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

      hasNewNotification.value = true;
      _triggerNotificationRefresh();

      log('Notification shown successfully');

    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  @override
  void onClose() {
    streamController.close();
    super.onClose();
  }
}