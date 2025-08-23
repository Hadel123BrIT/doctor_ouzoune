import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';

class MyProfileController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final RxString id = ''.obs;
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString role = ''.obs;
  final RxString clinicName = ''.obs;
  final RxString clinicAddress = ''.obs;
  final RxDouble clinicLongitude = 0.0.obs;
  final RxDouble clinicLatitude = 0.0.obs;
  final RxInt clinicId = 0.obs;
  final RxDouble rate = 0.0.obs;

  @override
  void onInit() {
    fetchProfileData();
    super.onInit();
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await apiServices.getMyProfile();

      id.value = response['id'] ?? '';
      userName.value = response['userName'] ?? '';
      email.value = response['email'] ?? '';
      phoneNumber.value = response['phoneNumber'] ?? '';
      role.value = response['role'] ?? '';
      rate.value = (response['rate'] ?? 0.0).toDouble();

      final clinic = response['clinic'];
      if (clinic != null) {
        clinicId.value = clinic['id'] ?? 0;
        clinicName.value = clinic['name'] ?? '';
        clinicAddress.value = clinic['address'] ?? '';
        clinicLongitude.value = (clinic['longtitude'] ?? 0.0).toDouble();
        clinicLatitude.value = (clinic['latitude'] ?? 0.0).toDouble();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile data');
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> updateProfile() async {
    try {
      final data = {
        'id': id.value,
        'userName': userName.value,
        'email': email.value,
        'phoneNumber': phoneNumber.value,
        'role': role.value,
        'rate': rate.value,
        'clinic': {
          'id': clinicId.value,
          'name': clinicName.value,
          'address': clinicAddress.value,
          'longtitude': clinicLongitude.value,
          'latitude': clinicLatitude.value,
        }
      };

      final response = await apiServices.updateMyProfile(data);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
      debugPrint('Error updating profile: $e');
    }
  }
}