import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ouzoun/core/services/api_services.dart';
import '../../Routes/app_routes.dart';
import '../../core/services/firebase_service.dart';
class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final clinicNameController=TextEditingController();
  final addressController=TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var selectedLocation = Rxn<LatLng>();
  var errorMessage="".obs;
  final ApiServices apiServices=ApiServices();
  final FirebaseService _firebaseService = Get.put(FirebaseService());


  void updateLocation(LatLng coords, String address) {
    selectedLocation.value = coords;
    locationController.text = address;
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
      throw 'Password must be at least 8 characters';
    }

    isLoading(true);

    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      final response = await apiServices.registerUser(
        userName: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        password: passwordController.text,
        clinicName: clinicNameController.text,
        address: addressController.text,
        longitude: selectedLocation.value!.longitude,
        latitude: selectedLocation.value!.latitude,
        deviceToken: deviceToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(AppRoutes.homepage);
        Get.snackbar('Success'.tr, 'Registration successful'.tr);
      } else {
        final errorData = response.data;
        if (errorData is List && errorData.isNotEmpty) {
          errorMessage(errorData[0]['description'] ?? 'Registration failed'.tr);
        } else if (errorData is Map) {
          errorMessage(errorData['message'] ?? 'Registration failed'.tr);
        } else {
          errorMessage('Registration failed'.tr);
        }
        Get.snackbar('Error'.tr, errorMessage.value);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is List && errorData.isNotEmpty) {
          errorMessage(errorData[0]['description'] ?? e.message ?? 'Registration failed'.tr);
        } else {
          errorMessage(e.message ?? 'Registration failed'.tr);
        }
      } else {
        errorMessage(e.message ?? 'Registration failed'.tr);
      }
      Get.snackbar('Error'.tr, errorMessage.value);
      print('Dio Error: ${e.toString()}');
    } catch (e) {
      errorMessage('An error occurred: ${e.toString()}'.tr);
      Get.snackbar('Error'.tr, errorMessage.value);
      print('General Error: ${e.toString()}');
    } finally {
      isLoading(false);
    }
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