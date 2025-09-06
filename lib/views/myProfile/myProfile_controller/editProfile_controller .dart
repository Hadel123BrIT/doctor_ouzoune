import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'myProfile_controller.dart';

class EditProfileController extends GetxController {
  final MyProfileController profileController = Get.find<MyProfileController>();

  // نترك جميع الحقول فارغة في البداية
  final userName = RxString('');
  final email = RxString('');
  final phoneNumber = RxString('');
  final clinicName = RxString('');
  final clinicAddress = RxString('');
  final location = RxString('');
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;

  final clinicLongitude = 0.0.obs;
  final clinicLatitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);

      // طباعة البيانات قبل الإرسال
      print('🔄 بدء عملية تحديث الملف الشخصي...');
      print('📝 البيانات المحلية قبل الإرسال:');
      print('   UserName: ${userName.value}');
      print('   Email: ${email.value}');
      print('   PhoneNumber: ${phoneNumber.value}');
      print('   ClinicName: ${clinicName.value}');
      print('   Address: ${clinicAddress.value}');
      print('   Longtitude: ${clinicLongitude.value}');
      print('   Latitude: ${clinicLatitude.value}');
      print('   Has Image: ${selectedImage.value != null}');

      // نرسل جميع الحقول فارغة مع القيم التي تم تعديلها فقط
      final data = {
        'UserName': userName.value,          // فارغ إذا لم يتغير
        'Email': email.value,                // فارغ إذا لم يتغير
        'PhoneNumber': phoneNumber.value,    // فارغ إذا لم يتغير
        'ClinicName': clinicName.value,      // فارغ إذا لم يتغير
        'Address': clinicAddress.value,      // فارغ إذا لم يتغير
        'Longtitude': clinicLongitude.value, // 0 إذا لم يتغير
        'Latitude': clinicLatitude.value,    // 0 إذا لم يتغير
      };

      // نرسل البيانات إلى السيرفر
      print('🚀 إرسال البيانات إلى السيرفر...');
      final response = await profileController.apiServices.updateMyProfile(
        data: data,
        profileImageFile: selectedImage.value,
      );

      if (response != null) {
        print('🎉 تم تحديث الملف الشخصي بنجاح!');
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // نعيد تحميل البيانات في المتحكم الرئيسي
        print('🔄 إعادة تحميل بيانات الملف الشخصي...');
        await profileController.fetchProfileData();

        Get.back();
      } else {
        print('⚠️ الاستجابة من السيرفر فارغة');
      }
    } catch (e) {
      print('❌ فشل في تحديث الملف الشخصي: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      print('✅ انتهت عملية التحديث');
      isLoading(false);
    }
  }

  void updateLocation(LatLng coords, String address) {
    print('📍 تحديث الموقع:');
    print('   الإحداثيات: ${coords.latitude}, ${coords.longitude}');
    print('   العنوان: $address');

    clinicLongitude.value = coords.longitude;
    clinicLatitude.value = coords.latitude;
    location.value = address;

    print('   ✅ تم حفظ الإحداثيات: ${clinicLatitude.value}, ${clinicLongitude.value}');
  }

  Future<void> pickImage() async {
    try {
      print('🖼️ محاولة اختيار صورة...');
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        print('✅ تم اختيار الصورة: ${image.path}');
        selectedImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Image selected successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('⚠️ لم يتم اختيار أي صورة');
      }
    } catch (e) {
      print('❌ فشل في اختيار الصورة: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}