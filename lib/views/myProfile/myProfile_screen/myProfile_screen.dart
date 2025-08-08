import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../myProfile_controller/myProfile_controller.dart';
import '../widget/buildProfileItem.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});
  final controller = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Obx(() => Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: context.height * 0.20,
            child: Container(
              color: AppColors.primaryGreen,
              child: Center(
                child: Text(
                  'My Personal Profile',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: context.height * 0.80,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.deepBlack : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: context.height * 0.05),
                      width: context.width * 0.35,
                      height: context.width * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 3,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo_App.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: context.height * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                      child: Column(
                        children: [
                          buildProfileItem(
                            context,
                            icon: Icons.person,
                            title: 'Name',
                            value: controller.userName.value,
                          ),
                          SizedBox(height: 10),
                          buildProfileItem(
                            context,
                            icon: Icons.email,
                            title: 'Email',
                            value: controller.email.value,
                          ),
                          SizedBox(height: 10),
                          buildProfileItem(
                            context,
                            icon: Icons.phone,
                            title: 'Phone',
                            value: controller.phoneNumber.value,
                          ),
                          SizedBox(height: 10),
                          buildProfileItem(
                            context,
                            icon: Icons.star,
                            title: 'Rating',
                            value: '${controller.rate.value}/5',
                          ),
                          SizedBox(height: 10),
                          buildProfileItem(
                            context,
                            icon: Icons.business,
                            title: 'Clinic Name',
                            value: controller.clinicName.value,
                          ),
                          SizedBox(height: 10),
                          buildProfileItem(
                            context,
                            icon: Icons.location_on,
                            title: 'Clinic Address',
                            value: controller.clinicAddress.value,
                          ),
                          SizedBox(height: context.height * 0.03),
                          CustomButton(
                            onTap: controller.updateProfile,
                            text: "Update my profile",
                            color: AppColors.primaryGreen,
                          ),
                          SizedBox(height: context.height * 0.05),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}