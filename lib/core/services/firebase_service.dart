import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'LocalNotificationService .dart';

class FirebaseServices {
  static FirebaseMessaging messaging=FirebaseMessaging.instance;
  static Future init()async{
    await messaging.requestPermission();
    String? fireBaseToken=await messaging.getToken();
    print("device token$fireBaseToken");
    getDeviceToken();
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessaging);
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      LocalNotificationService.showBasicNotification(message);
    });
  }
  static Future<String?> getDeviceToken() async {

    String? token = await messaging.getToken();
    print("***************************Device Token: $token");
    return token;
  }
  static Future<void> handelBackgroundMessaging(RemoteMessage message)async{
    print(message.notification?.title);
    print(message.notification?.body);
  }


}