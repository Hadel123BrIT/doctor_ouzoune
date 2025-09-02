import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_services.dart';

class RateController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final noteController = TextEditingController();
  final assistantId = ''.obs;
  final selectedAssistantName = ''.obs;
  final assistantsList = <Map<String, dynamic>>[].obs;
  final rate = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAssistants();
  }



  void selectAssistant(String id, String name) {
    assistantId.value = id;
    selectedAssistantName.value = name;
  }

  Future<void> submitRating() async {
    if (assistantId.value.isEmpty) {
      Get.snackbar('Error', 'Please select an assistant');
      return;
    }

    if (rate.value == 0) {
      Get.snackbar('Error', 'Please select a rating');
      return;
    }

    try {
      isLoading.value = true;
      final token = GetStorage().read('auth_token');

      final response = await apiServices.submitRating(
        note: noteController.text,
        rate: rate.value,
        assistantId: assistantId.value,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar('Success', 'Rating submitted successfully');
        noteController.clear();
        rate.value = 0;
        assistantId.value = '';
      } else {
        throw Exception('Failed to submit rating: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      Get.snackbar('Error', 'Failed to submit rating: ${e.message}');
    } catch (e) {
      print('Unexpected Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAssistants() async {
    try {
      isLoading.value = true;
      final token = GetStorage().read('auth_token');

      if (token == null) {

        return;
      }

      final assistants = await apiServices.getAssistantsFromProcedures(token);

      assistantsList.assignAll(assistants);

    } catch (e) {


      Get.snackbar('Error', 'Failed to load assistants');
    } finally {
      isLoading.value = false;
    }
  }
}