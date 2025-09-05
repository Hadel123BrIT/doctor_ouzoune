import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/core/services/api_services.dart';

class ChangePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final ApiServices apiServices = Get.find<ApiServices>();

  Future<void> changePassword() async {
    print('🔄 Starting change password process...');

    try {
      if (!formKey.currentState!.validate()) {
        print('❌ Form validation failed');
        return;
      }

      if (newPasswordController.text != confirmPasswordController.text) {
        print('❌ Passwords do not match');
        Get.snackbar('Error', 'Passwords do not match'.tr);
        return;
      }

      isLoading.value = true;
      print('⏳ Loading started');

      final response = await apiServices.changePassword(
        newPassword: newPasswordController.text,
        confirmNewPassword: confirmPasswordController.text,
        oldPassword: oldPasswordController.text,
      );

      print('✅ API call completed');
      print('📊 Status code: ${response.statusCode}');
      print('📊 Response data: ${response.data}');

      // Handle 204 No Content response
      if (response.statusCode == 204) {
        print('🎉 Password change successful (204 No Content)');
        Navigator.of(Get.context!).pop();
        Get.snackbar('Success', 'Password changed successfully'.tr);
      }
      // Handle other success status codes
      else if (response.statusCode == 200 || response.statusCode == 201) {
        print('🎉 Password change successful');
        Navigator.of(Get.context!).pop();
        Get.snackbar('Success', 'Password changed successfully'.tr);
      }

      else {
        String errorMessage;

        // Check if response.data is a Map and contains error information
        if (response.data is Map<String, dynamic>) {
          errorMessage = (response.data as Map)['message'] ??
              (response.data as Map)['error'] ??
              'Password change failed with status ${response.statusCode}';
        }
        // If response.data is not a Map (could be String, null, etc.)
        else {
          errorMessage = 'Password change failed with status ${response.statusCode}';
        }

        print('❌ Error: $errorMessage');
        Get.snackbar('Error', errorMessage.tr);
      }
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: $stackTrace'); // هذا سيعطيك معلومات عن مكان الخطأ

      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}'.tr);
    } finally {
      isLoading.value = false;
      print('⏹️ Loading finished');
    }
  }

  bool isPasswordStrong(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    oldPasswordController.dispose();
    super.onClose();
  }
}