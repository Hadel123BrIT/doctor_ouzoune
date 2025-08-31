import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/api_services.dart';
import '../../register/Widget/LocationPicker/locationPicker_controller.dart';
import '../myProfile_screen/myProfile_screen.dart';

class MyProfileController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final LocationPickerController locationController = Get.put(
      LocationPickerController());

  final id = ''.obs;
  final userName = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final role = 'User'.obs;
  final rate = 0.0.obs;
  final clinicId = 0.obs;
  final clinicName = ''.obs;
  final clinicAddress = ''.obs;
  final clinicLongitude = 0.0.obs;
  final clinicLatitude = 0.0.obs;
  final profileImagePath = ''.obs;
  var location = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final isConvertingAddress = false.obs;

  void onInit() {
    super.onInit();
    fetchProfileData();
  }


  Future<void> fetchProfileData() async {
    try {
      isLoading(true);
      final response = await apiServices.getMyProfile();

      id.value = response['id'] ?? '';
      userName.value = response['userName'] ?? '';
      email.value = response['email'] ?? '';
      phoneNumber.value = response['phoneNumber'] ?? '';
      role.value = response['role'] ?? '';
      rate.value = (response['rate'] ?? 0.0).toDouble();
      profileImagePath.value = response['profileImagePath'] ?? '';

      final clinic = response['clinic'];
      if (clinic != null) {
        clinicId.value = clinic['id'] ?? 0;
        clinicName.value = clinic['name'] ?? '';
        clinicAddress.value = clinic['address'] ?? '';
        clinicLongitude.value = (clinic['longtitude'] ?? 0.0).toDouble();
        clinicLatitude.value = (clinic['latitude'] ?? 0.0).toDouble();
        await convertCoordinatesToAddress(
            clinicLatitude.value, clinicLongitude.value);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile data');
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoading(false);
    }
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
      Get.snackbar('Error', 'Failed to pick image');
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);

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

      final response = await apiServices.updateMyProfile(
        data: data,
        profileImageFile: selectedImage.value,
      );

      Get.snackbar('Success', 'Profile updated successfully');
      if (selectedImage.value != null) {
        await fetchProfileData();
        print("yes");

      }
      selectedImage.value = null;
      Get.to(MyProfileScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
      debugPrint('Error updating profile: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> convertCoordinatesToAddress(double latitude,
      double longitude) async {
    try {
      if (latitude == 0.0 && longitude == 0.0) {
        location.value = 'Location not set';
        return;
      }

      final latLng = LatLng(latitude, longitude);
      await locationController.onMapTapped(latLng);
      await Future.delayed(Duration(milliseconds: 500));
      location.value = locationController.locationName.value;
    } catch (e) {
      debugPrint('Error converting coordinates: $e');
      location.value =
      'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(
          4)}';
    }
  }
}