import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/CustomSnackbar .dart';
import 'myProfile_controller.dart';

class EditProfileController extends GetxController {
  final MyProfileController profileController = Get.put(MyProfileController());

  final userName = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final clinicName = ''.obs;
  final clinicAddress = ''.obs;
  final location = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
   clearAllFields();
  }

  void clearAllFields() {
    userName.value = "";
    email.value = '';
    phoneNumber.value = '';
    clinicName.value = '';
    clinicAddress.value = '';
    location.value = '';
    selectedImage.value = null;
  }

  Future<void> updateProfile() async {
    profileController.userName.value = userName.value;
    profileController.email.value = email.value;
    profileController.phoneNumber.value = phoneNumber.value;
    profileController.clinicName.value = clinicName.value;
    profileController.clinicAddress.value = clinicAddress.value;
    profileController.selectedImage.value = selectedImage.value;

    await profileController.updateProfile();
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
}