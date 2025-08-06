// utils/register_helpers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/Widgets/custom_text_form_field.dart' hide CustomTextFormField;
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../login/login_screen.dart';
import '../register_controller.dart';
import 'LocationPicker/locationPicker .dart';

class RegisterHelpers {
  static Widget buildLoadingIndicator() {
    return Center(
      child: Lottie.asset(
        '',
        fit: BoxFit.cover,
        repeat: true,
        height: 150,
        width: 150,
      ),
    );
  }

  static Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.height * 0.04),
        Text(
          "Sign Up".tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: context.height * 0.04),
        Text(
          "Sign in to your account and then continue using this app".tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: context.height * 0.04),
      ],
    );
  }

  static Widget buildNameField( TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.person,
          color: Colors.grey[500]
      ),
      validator: (val) => val?.isEmpty ?? true ? "Name must not be empty".tr : null,
      myController: controller,
      hintText: "Enter your Name".tr,
      obscureText: false,
    );
  }

  static Widget buildLocationField( RegisterController controller,) {
    return InkWell(
      onTap: () async {
        Get.dialog(
          Center(child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
          ),
          barrierDismissible: false,
        );

        try {
          await Get.to(() => LocationPicker(
            onLocationSelected: (coords, address) {
              controller.updateLocation(coords, address);
            },
            useOSM: true,
          ));

          if (Get.isDialogOpen!) Get.back();
        } catch (e) {
          if (Get.isDialogOpen!) Get.back();
          Get.snackbar(
            'Error'.tr,
            'Failed to load map: ${e.toString()}'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: IgnorePointer(
        child: CustomTextFormField(
          prefixIcon: Icon(Icons.location_on, color: Colors.grey[500]),
          validator: (val) => val?.isEmpty ?? true ? "Location must not be empty".tr : null,
          hintText: controller.selectedLocation.value == null
              ? "Tap to select location".tr
              : "Location selected. Tap to change".tr,
          obscureText: false,
          suffixIcon: controller.selectedLocation.value != null
              ? Icon(Icons.check_circle, color: Colors.green)
              : null,
          myController: controller.locationController,
        ),
      ),
    );
  }

  static Widget buildPhoneField( TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.phone,
          color: Colors.grey[500]
      ),
      validator: (val) => val?.isEmpty ?? true ? "Phone must not be empty".tr : null,
      myController: controller,
      hintText: "Enter your phone".tr,
      obscureText: false,
    );
  }

  static Widget buildEmailField( TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.email,
          color: Colors.grey[500]
      ),
      validator: (val) => val?.isEmpty ?? true ? "Email must not be empty".tr : null,
      myController: controller,
      hintText: "Enter your Email".tr,
      obscureText: false,
    );
  }

  static Widget buildPasswordField( TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.lock,
          color: Colors.grey[500]
      ),
      suffixIcon: Icon(
        Icons.remove_red_eye_outlined,
        color: Colors.grey[500],
      ),
      validator: (val) => val?.isEmpty ?? true ? "Password must not be empty".tr : null,
      obscureText: true,
      myController: controller,
      hintText: 'Enter Your Password'.tr,
    );
  }

  static Widget buildForgotPasswordLink(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.chekEmail),
      child: Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(
          top: context.height * 0.01,
          bottom: context.height * 0.02,
        ),
        child: Text(
          "Forgot Password ?".tr,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: context.width * 0.03,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  static Widget buildClinicField(TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.medical_services, color: Colors.grey[500]),
      validator: (val) => val?.isEmpty ?? true ? "Clinic name must not be empty".tr : null,
      myController: controller,
      hintText: "Enter clinic name".tr,
      obscureText: false,
    );
  }

  static Widget buildAddressField(TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.location_city, color: Colors.grey[500]),
      validator: (val) => val?.isEmpty ?? true ? "Address must not be empty".tr : null,
      myController: controller,
      hintText: "Enter your address".tr,
      obscureText: false,
    );
  }

  static Widget buildSignUpButton(RegisterController controller) {
    return Obx(
          () => CustomButton(
        onTap: () async {
          if (controller.isLoading.value) return;
          await controller.register();

        },
        text: controller.isLoading.value ? 'Loading...'.tr : 'Sign Up'.tr,
        color: AppColors.primaryGreen,
      ),
    );
  }

  static Widget buildLoginLink(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => Get.to(() => LoginScreen()),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: "you have an account ? ".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.width * 0.04,
                fontFamily: "Montserrat",
              ),
            ),
            TextSpan(
              text: "Login".tr,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: context.width * 0.04,
                fontFamily: "Montserrat",
              ),
            ),
          ]),
        ),
      ),
    );
  }

}