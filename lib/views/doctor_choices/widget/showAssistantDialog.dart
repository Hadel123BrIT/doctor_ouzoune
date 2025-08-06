import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../Doctor_choices_controller/doctor_choices_controller.dart';

void showAssistantsDialog(BuildContext context) {
  final DoctorChoicesController controller = Get.put(DoctorChoicesController());
  Get.dialog(
    AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Select Number of Assistants",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.primaryGreen,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Choose how many assistants you need (1-5)",
            style: TextStyle(
              fontSize: 14,
                fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final number = index + 1;
              return GestureDetector(
                onTap: () => controller.selectAssistants(number),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: controller.tempSelection.value == number
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: controller.tempSelection.value == number
                            ? AppColors.whiteBackground
                            : AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )),
          const SizedBox(height: 20),
          Obx(() => Text(
            controller.tempSelection.value > 0
                ? 'Selected: ${controller.tempSelection.value}'
                : 'Please select a number',
            style: TextStyle(color: AppColors.primaryGreen,
              fontFamily: 'Montserrat',
            ),
          )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.resetSelection();
            Get.back();
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: AppColors.primaryGreen),
          ),
        ),
        Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: controller.tempSelection.value > 0
              ? () {
            controller.confirmSelection();
            Get.back();
          }
              : null,
          child: Text(
            "Confirm",
            style: TextStyle(color: AppColors.whiteBackground),
          ),
        )),
      ],
    ),
  );
}