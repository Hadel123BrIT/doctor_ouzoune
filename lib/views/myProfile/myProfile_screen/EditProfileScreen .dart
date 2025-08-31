import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../myProfile_controller/myProfile_controller.dart';
import '../widget/BuildEditableProfileItem .dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final controller = Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),
          color: Colors.white, onPressed: () { Get.back(); },
        ),
        toolbarHeight: context.height* 0.1, // 80 replaced
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06), // 22 replaced
          ),
        ),
        title: Text(
          "Edit My Profile",
          style: Theme.of(context).textTheme.titleSmall,
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
                height: 200
            ),
          );;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
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
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              BuildEditableProfileItem(
                icon: Icons.person,
                title: 'Name',
                value: controller.userName.value,
                onChanged: (value) => controller.userName.value = value,
              ),
              SizedBox(height: 25),
              BuildEditableProfileItem(
                icon: Icons.email,
                title: 'Email',
                value: controller.email.value,
                onChanged: (value) => controller.email.value = value,
              ),
              SizedBox(height: 25),

              BuildEditableProfileItem(
                icon: Icons.phone,
                title: 'Phone',
                value: controller.phoneNumber.value,
                onChanged: (value) => controller.phoneNumber.value = value,
              ),
              SizedBox(height: 25),
              BuildEditableProfileItem(
                icon: Icons.location_on,
                title: 'Location',
                value: controller.location.value,
                onChanged: (value) => controller.location.value = value,
              ),
              SizedBox(height: 25),
              BuildEditableProfileItem(
                icon: Icons.medical_services,
                title: 'Clinic Name',
                value: controller.clinicName.value,
                onChanged: (value) => controller.clinicName.value = value,
              ),
              SizedBox(height: 25),

              BuildEditableProfileItem(
                icon: Icons.location_city,
                title: 'Clinic Address',
                value: controller.clinicAddress.value,
                onChanged: (value) => controller.clinicAddress.value = value,
              ),
              SizedBox(height: 30),

              CustomButton(

                 onTap: controller.updateProfile,
                text: "Save Changes",
                color: AppColors.primaryGreen,
              ),
            ],
          ),
        );
      }),
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
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 60, color: Colors.grey[600]);
          },
        ),
      );
    } else {
      return Icon(Icons.person, size: 60, color: Colors.grey[600]);
    }
  }
}