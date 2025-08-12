// lib/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static Future<String?> getDeviceToken() async {
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();
    print("***************************Device Token: $token");
    return token;
  }
}