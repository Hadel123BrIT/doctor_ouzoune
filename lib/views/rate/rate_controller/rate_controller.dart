import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/app_colors.dart';

class RateController extends GetxController {
  final noteController = TextEditingController();
  final assistantId = ''.obs;
  final rate = 0.0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // يمكنك الحصول على assistantId من المعلمات عند الانتقال إلى هذه الصفحة
    assistantId.value = Get.arguments['assistantId'] ?? '';
  }

  Future<void> submitRating() async {
    if (rate.value == 0) {
      Get.snackbar(
        'Error'.tr,
        'Please select a rating'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final token = GetStorage().read('auth_token');

      final response = await Dio().post(
        "http://ouzon.somee.com/api/Ratings",
        data: {
          "note": noteController.text,
          "rate": rate.value,
          "assistantId": assistantId.value,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // العودة للصفحة السابقة بعد التقييم
        Get.snackbar(
          'Success'.tr,
          'Rating submitted successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.response?.data['message'] ?? 'Failed to submit rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}