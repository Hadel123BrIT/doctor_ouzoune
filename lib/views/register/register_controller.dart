// RegisterController.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouzoun/core/services/api_services.dart';
import '../../Routes/app_routes.dart';
import '../../core/services/firebase_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final clinicNameController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var selectedLocation = Rxn<LatLng>();
  var errorMessage = "".obs;
  var selectedImage = Rxn<File>();
  final ApiServices apiServices = ApiServices();
  final FirebaseServices _firebaseService = Get.put(FirebaseServices());

  void updateLocation(LatLng coords, String address) {
    print(coords);
    selectedLocation.value = coords;
    locationController.text = address;
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to pick image: $e'.tr);
    }
  }


  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar('Error'.tr, 'Please fill all fields correctly'.tr);
      return;
    }

    if (selectedLocation.value == null) {
      Get.snackbar('Error'.tr, 'Please select a location'.tr);
      return;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar('Error'.tr, 'Password must be at least 8 characters'.tr);
      return;
    }

    if (selectedImage.value != null) {
      final allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
      final filePath = selectedImage.value!.path.toLowerCase();
      final hasValidExtension = allowedExtensions.any((ext) => filePath.endsWith(ext));

      if (!hasValidExtension) {
        Get.snackbar('Error'.tr, 'Only .jpg, .png, .webp, .jpeg are allowed'.tr);
        return;
      }
    }

    isLoading(true);

    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      final response = await apiServices.registerUserWithImage(
        userName: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        password: passwordController.text,
        clinicName: clinicNameController.text,
        address: addressController.text,
        longitude: selectedLocation.value!.longitude,
        latitude: selectedLocation.value!.latitude,
        deviceToken: deviceToken,
        ProfilePicture: selectedImage.value,
      );

      print('Registration Response: ${response.statusCode}');
      print('Registration Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(AppRoutes.homepage);
        Get.snackbar('Success'.tr, 'Registration successful'.tr);
      } else {
        _handleRegistrationError(response);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      print('General Error: ${e.toString()}');
      print('Error Type: ${e.runtimeType}');
      errorMessage('An unexpected error occurred'.tr);
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
  void _handleRegistrationError(Response response) {
    final errorData = response.data;
    print('Error Response Data: $errorData');
    print('Error Status Code: ${response.statusCode}');

    try {
      if (errorData is List) {
        if (errorData.isNotEmpty && errorData[0] is Map) {
          errorMessage(errorData[0]['description'] ?? 'Registration failed'.tr);
        } else {
          errorMessage('Registration failed'.tr);
        }
      } else if (errorData is Map) {
        errorMessage(errorData['message'] ?? 'Registration failed'.tr);
      } else if (errorData is String) {
        errorMessage(errorData);
      } else {
        errorMessage('Registration failed: ${response.statusCode}'.tr);
      }
    } catch (e) {
      print('Error parsing error response: $e');
      errorMessage('Registration failed'.tr);
    }

    Get.snackbar('Error'.tr, errorMessage.value);
  }

  void _handleDioError(DioException e) {
    print('Dio Error: ${e.toString()}');
    print('Dio Response: ${e.response?.data}');
    print('Dio Status Code: ${e.response?.statusCode}');

    try {
      if (e.response != null) {
        final errorData = e.response?.data;

        if (errorData is List) {
          if (errorData.isNotEmpty && errorData[0] is Map) {
            errorMessage(errorData[0]['description'] ?? e.message ?? 'Registration failed'.tr);
          } else {
            errorMessage(e.message ?? 'Registration failed'.tr);
          }
        } else if (errorData is Map) {
          errorMessage(errorData['message'] ?? e.message ?? 'Registration failed'.tr);
        } else if (errorData is String) {
          errorMessage(errorData);
        } else {
          errorMessage(e.message ?? 'Registration failed'.tr);
        }
      } else {
        errorMessage(e.message ?? 'Registration failed'.tr);
      }
    } catch (e) {
      print('Error parsing dio error: $e');
      errorMessage('Registration failed'.tr);
    }

    Get.snackbar('Error'.tr, errorMessage.value);
  }
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    locationController.dispose();
    phoneController.dispose();
    clinicNameController.dispose();
    addressController.dispose();
    super.onClose();
  }
}