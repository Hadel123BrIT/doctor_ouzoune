import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/core/constants/app_images.dart';

import '../myProfile_controller/myProfile_controller.dart';
import '../widget/BuildEditableProfileItem .dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final controller = Get.find<MyProfileController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text(
          "Edit My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Lottie.asset(
              AppAssets.LoadingAnimation,
              fit: BoxFit.cover,
              repeat: true,
              width: 200,
              height: 200,
            ),
          );
        }

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [

                _buildProfileImageSection(context),
                SizedBox(height: 30),

                _buildEditableFields(),

                SizedBox(height: 30),
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.updateProfile();
                    }
                  },
                  text: "Save Changes",
                  color: AppColors.primaryGreen,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: controller.pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: AppColors.primaryGreen,
                    width: 3,
                  ),
                ),
                child: _buildProfileImage(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Tap to change photo',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (controller.selectedImage.value != null) {
      return ClipOval(
        child: Image.file(
          controller.selectedImage.value!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else if (controller.profileImagePath.value.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          controller.profileImagePath.value,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 60, color: Colors.grey[400]);
          },
        ),
      );
    } else {
      return Icon(Icons.person, size: 60, color: Colors.grey[400]);
    }
  }

  Widget _buildEditableFields() {
    return Column(
      children: [
        BuildEditableProfileItem(
          icon: Icons.person,
          title: 'Name',
          initialValue: controller.userName.value,
          onChanged: (value) => controller.userName.value = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.email,
          title: 'Email',
          initialValue: controller.email.value,
          onChanged: (value) => controller.email.value = value,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.phone,
          title: 'Phone',
          initialValue: controller.phoneNumber.value,
          onChanged: (value) => controller.phoneNumber.value = value,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.location_on,
          title: 'Location',
          initialValue: controller.location.value,
          onChanged: (value) => controller.location.value = value,
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.medical_services,
          title: 'Clinic Name',
          initialValue: controller.clinicName.value,
          onChanged: (value) => controller.clinicName.value = value,
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.location_city,
          title: 'Clinic Address',
          initialValue: controller.clinicAddress.value,
          onChanged: (value) => controller.clinicAddress.value = value,
        ),
      ],
    );
  }
}