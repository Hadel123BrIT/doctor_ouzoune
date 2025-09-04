import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as box;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  final isDarkMode = false.obs;
  late final GetStorage box;

  @override
  void onInit() {
    super.onInit();
    box = GetStorage();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    try {
      isDarkMode.value = box.read<bool>('isDarkMode') ?? false;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      print('Error loading theme preference: $e');
      isDarkMode.value = false;
    }
  }

  void toggleTheme() {
    try {
      isDarkMode.toggle();
      box.write('isDarkMode', isDarkMode.value); // حفظ القيمة
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      Get.snackbar(
        'Theme Changed',
        isDarkMode.value ? 'Dark Mode Activated' : 'Light Mode Activated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error toggling theme: $e');
      Get.snackbar('Error', 'Failed to change theme');
    }
  }
}