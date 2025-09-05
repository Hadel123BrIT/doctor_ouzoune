import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_services.dart';
import '../../../widgets/CustomSnackbar .dart';

class RateController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final noteController = TextEditingController();
  final assistantId = ''.obs;
  final selectedAssistantName = ''.obs;
  final assistantsList = <Map<String, dynamic>>[].obs;
  final rate = 0.obs;
  final isLoading = false.obs;
  final hasNoAssistants = false.obs;

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
      CustomSnackbar.error(message: 'Please select an assistant');
      return;
    }

    if (rate.value == 0) {
      CustomSnackbar.error(message: 'Please select a rating');
      return;
    }

    try {
      isLoading.value = true;
      final token = GetStorage().read('auth_token');

      if (token == null) {
        CustomSnackbar.error(message: 'Please login again');
        return;
      }

      final response = await apiServices.submitRating(
        note: noteController.text,
        rate: rate.value,
        assistantId: assistantId.value,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        CustomSnackbar.success(message: 'Rating submitted successfully');
        noteController.clear();
        rate.value = 0;
        assistantId.value = '';
      } else {
        throw Exception('Failed to submit rating: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      CustomSnackbar.error(message: 'Failed to submit rating: ${e.message}');
    } catch (e) {
      print('Unexpected Error: $e');
      CustomSnackbar.error(message: 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAssistants() async {
    try {
      isLoading.value = true;
      hasNoAssistants.value = false;

      final token = GetStorage().read('auth_token');

      if (token == null) {
        CustomSnackbar.error(message: 'Please login again');
        return;
      }

      final assistants = await apiServices.getAssistantsFromProcedures(token);

      if (assistants.isEmpty) {
        hasNoAssistants.value = true;
        CustomSnackbar.info(
          message: 'No assistants found in your procedures',
          duration: Duration(seconds: 5),
        );
      } else {
        assistantsList.assignAll(assistants);
        print('Loaded ${assistantsList.length} assistants');
      }

    } on DioException catch (e) {
      print('Dio Error loading assistants: ${e.message}');
      CustomSnackbar.error(message: 'Failed to load assistants');
    } catch (e) {
      print('Unexpected Error loading assistants: $e');
      CustomSnackbar.error(message: 'Failed to load assistants');
    } finally {
      isLoading.value = false;
    }
  }


}