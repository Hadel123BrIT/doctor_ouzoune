import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/services/api_services.dart';

class MyProfileController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString clinicName = ''.obs;
  final RxString clinicAddress = ''.obs;
  final RxDouble rate = 0.0.obs;

  @override
  void onInit() {
    fetchProfileData();
    super.onInit();
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await apiServices.getMyProfile();

      userName.value = response['userName'] ?? '';
      email.value = response['email'] ?? '';
      phoneNumber.value = response['phoneNumber'] ?? '';
      rate.value = response['rate']?.toDouble() ?? 0.0;
      final clinic = response['clinic'];
      if (clinic != null) {
        clinicName.value = clinic['name'] ?? '';
        clinicAddress.value = clinic['address'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile data');
    }
  }


  Future<void> updateProfile() async {
    try {
      final data = {
        'userName': userName.value,
        'email': email.value,
        'phoneNumber': phoneNumber.value,
        'clinic': {
          'name': clinicName.value,
          'address': clinicAddress.value,
        }
      };

      final response = await apiServices.updateMyProfile(data);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }
}