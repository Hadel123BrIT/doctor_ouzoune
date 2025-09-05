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
import '../../widgets/CustomSnackbar .dart';

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
      CustomSnackbar.error(message: 'Failed to pick image: $e');
    }
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      CustomSnackbar.error(message: 'Please fill all fields correctly');
      return;
    }

    if (selectedLocation.value == null) {
      CustomSnackbar.error(message: 'Please select a location');
      return;
    }

    if (passwordController.text.length < 8) {
      CustomSnackbar.error(message: 'Password must be at least 8 characters');
      return;
    }

    if (selectedImage.value != null) {
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      final fileExtension = selectedImage.value!.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(fileExtension)) {
        CustomSnackbar.error(message: 'Only .jpg, .png, .webp, .jpeg are allowed');
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(AppRoutes.homepage);
        CustomSnackbar.success(message: 'Registration successful, Welcome');
      } else {
        _handleRegistrationError(response);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      print('General Error: ${e.toString()}');
      CustomSnackbar.error(message: 'An unexpected error occurred: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void _handleRegistrationError(Response response) {
    final errorData = response.data;
    print('Error Response Data: $errorData');
    print('Error Status Code: ${response.statusCode}');

    String errorMessage = 'Registration failed';

    try {
      if (errorData is List) {
        if (errorData.isNotEmpty && errorData[0] is Map) {
          errorMessage = errorData[0]['description'] ?? 'Registration failed';
        }
      } else if (errorData is Map) {
        errorMessage = errorData['message'] ?? 'Registration failed';
      } else if (errorData is String) {
        errorMessage = errorData;
      } else {
        errorMessage = 'Registration failed: ${response.statusCode}';
      }
    } catch (e) {
      print('Error parsing error response: $e');
      errorMessage = 'Registration failed';
    }

    CustomSnackbar.error(message: errorMessage);
  }

  void _handleDioError(DioException e) {
    print('Dio Error: ${e.toString()}');
    print('Dio Response: ${e.response?.data}');
    print('Dio Status Code: ${e.response?.statusCode}');

    String errorMessage = 'Registration failed';

    try {
      if (e.response != null) {
        final errorData = e.response?.data;

        if (errorData is List) {
          if (errorData.isNotEmpty && errorData[0] is Map) {
            errorMessage = errorData[0]['description'] ?? e.message ?? 'Registration failed';
          }
        } else if (errorData is Map) {
          errorMessage = errorData['message'] ?? e.message ?? 'Registration failed';
        } else if (errorData is String) {
          errorMessage = errorData;
        } else {
          errorMessage = e.message ?? 'Registration failed';
        }
      } else {
        errorMessage = e.message ?? 'Registration failed';
      }
    } catch (e) {
      print('Error parsing dio error: $e');
      errorMessage = 'Registration failed';
    }

    CustomSnackbar.error(message: errorMessage);
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