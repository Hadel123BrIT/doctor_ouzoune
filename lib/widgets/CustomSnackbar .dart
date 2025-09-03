import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    SnackPosition position = SnackPosition.TOP,
    EdgeInsets margin = const EdgeInsets.all(15),
    IconData? icon,
  }) {
    Get.snackbar(
      title,
      message,
      duration: duration,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: position,
      margin: margin,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      titleText: Text(
        title,
        style: TextStyle(
          fontFamily:'Montserrat',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontFamily:'Montserrat',
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }

  static void success({
    required String message,
    String title = 'Success',
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: Colors.grey[500]!,
      icon: Icons.check_circle,
    );
  }

  static void error({
    required String message,
    String title = 'Error',
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  static void warning({
    required String message,
    String title = 'Warning',
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  static void info({
    required String message,
    String title = 'Info',
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }
}