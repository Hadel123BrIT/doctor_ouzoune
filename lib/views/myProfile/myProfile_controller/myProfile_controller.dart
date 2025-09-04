import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/api_services.dart';
import '../../../widgets/CustomSnackbar .dart';
import '../../register/Widget/LocationPicker/locationPicker_controller.dart';
import '../myProfile_screen/myProfile_screen.dart';

class MyProfileController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final LocationPickerController locationController = Get.put(LocationPickerController());


  final  id = ''.obs;
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



  @override
  void onInit() {
    super.onInit();
    if (Get.currentRoute == '/profile') {
      fetchProfileData();
    }
    else{
      clearAllFields();
    }
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading(true);

      final response = await apiServices.getMyProfile();

      if (response.isEmpty) {
        CustomSnackbar.warning(
          message: 'No profile data found',
          title: 'Profile',
        );
        return;
      }

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


    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        CustomSnackbar.error(
          message: 'Session expired. Please login again',
          title: 'Authentication Error',
        );

      } else if (e.type == DioExceptionType.connectionTimeout) {
        CustomSnackbar.error(
          message: 'Connection timeout. Please check your internet',
          title: 'Network Error',
        );
      } else {
        CustomSnackbar.error(
          message: 'Network error: ${e.message ?? "Unknown error"}',
          title: 'Profile Error',
        );
      }
      debugPrint('Dio error fetching profile: $e');

    } catch (e) {
      CustomSnackbar.error(
        message: 'Failed to load profile data: ${e.toString()}',
        title: 'Profile Error',
      );
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);

      final data = {
        'userName': userName.value,
        'email': email.value,
        'phoneNumber': phoneNumber.value,
        'clinicName': clinicName.value,
        'clinicAddress': clinicAddress.value,
        'clinicLatitude': clinicLatitude.value,
        'clinicLongitude': clinicLongitude.value,
      };

      final response = await apiServices.updateMyProfile(
        data: data,
        profileImageFile: selectedImage.value,
      );

      if (response != null) {
        if (response['profileImagePath'] != null) {
          profileImagePath.value = response['profileImagePath'];
        }

        CustomSnackbar.success(message: 'Profile updated successfully');
        Get.back();
      }
    } catch (e) {
      CustomSnackbar.error(message: 'Failed to update profile: ${e.toString()}');
      debugPrint('Error updating profile: $e');
    } finally {
      isLoading(false);
      selectedImage.value = null;
    }
  }



  void clearAllFields() {
    userName.value="";
    email.value = '';
    phoneNumber.value = '';
    clinicName.value = '';
    clinicAddress.value = '';
    location.value = '';
    selectedImage.value = null;

    CustomSnackbar.info(
      message: 'All fields cleared',
      title: 'Cleared',
    );
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
        CustomSnackbar.success(
          message: 'Image selected successfully',
          title: 'Success',
        );
      }
    } catch (e) {
      CustomSnackbar.error(
        message: 'Failed to pick image: ${e.toString()}',
        title: 'Error',
      );
      debugPrint('Error picking image: $e');
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