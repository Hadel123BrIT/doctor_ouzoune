import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/core/services/api_services.dart';
import '../../Routes/app_routes.dart';
import '../../core/services/firebase_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  ApiServices apiServices = ApiServices();
  final FirebaseService _firebaseService = Get.put(FirebaseService());

  Future<void> login(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isLoading(true);
      try {
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        final response = await apiServices.loginUser(
          email: emailController.text,
          password: passwordController.text,
          deviceToken: deviceToken,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final token = response.data['token'];
          print("***********************************Token: $token");
          final box = GetStorage();
          await box.write('--------------------------user_token', token);
          await GetStorage().write('auth_token', token.toString());
          print('تم تخزين التوكن: ${GetStorage().read('auth_token')}');
          print('device token ${await FirebaseMessaging.instance.getToken()}');
          Get.snackbar('Success', 'Login successful',
            margin: EdgeInsets.all(15),

          );
          Get.offAllNamed(AppRoutes.homepage);
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      } finally {
        isLoading(false);
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields',

      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}