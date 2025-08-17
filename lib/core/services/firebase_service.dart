import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static FirebaseMessaging messaging= FirebaseMessaging.instance;
  static Future init() async{
    await messaging.requestPermission();
    getDeviceToken();
    //notification on background and killed
    FirebaseMessaging.onBackgroundMessage(handlebackgroundMessage);
  }
  static Future<String?> getDeviceToken() async {

    String? token = await messaging.getToken();
    print("***************************Device Token: $token");
    return token;
  }
  static Future<void> handlebackgroundMessage(RemoteMessage message) async{
    await Firebase.initializeApp();
    print("----------------------------");
    log(message.notification!.title??"nul");
  }
}