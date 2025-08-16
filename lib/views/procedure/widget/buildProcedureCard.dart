import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';
import '../procedure_screen/procedure_detail_screen.dart';

Widget buildProcedureCard(Procedure procedure, BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final controller = Get.find<ProcedureController>();

  return Card(
    color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.width * 0.025),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    margin: EdgeInsets.symmetric(vertical: context.height * 0.02),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Procedure ${procedure.id ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Chip(
                label: Text(
                  procedure.statusText ?? 'Unknown',
                  style: TextStyle(fontFamily: "Montserrat"),
                ),
                backgroundColor: procedure.statusColor ?? Colors.grey,
                labelStyle: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Doctor: ${procedure.doctor?.userName ?? 'No doctor assigned'}',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Date: ${procedure.date != null ? DateFormat('yyyy-MM-dd').format(procedure.date!) : 'N/A'}',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Time: ${procedure.date != null ? DateFormat('HH:mm').format(procedure.date!) : 'N/A'}',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Assistants: ${procedure.numberOfAssistants ?? 0}',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return CustomButton(
              onTap: () async {
                try {
                  if (procedure.id == null) {
                    throw Exception('Procedure ID is null');
                  }

                  await controller.fetchProcedureDetails(procedure.id!);

                  if (controller.selectedProcedure.value != null &&
                      controller.selectedProcedure.value!.id != null) {
                    Get.to(
                          () => ProcedureDetailScreen(
                        procedureId: controller.selectedProcedure.value!.id!,
                      ),
                    );
                  } else {
                    Get.snackbar(
                      'Error'.tr,
                      'Failed to load procedure details'.tr,
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error'.tr,
                    'Failed to load details: ${e.toString()}'.tr,
                  );
                }
              },
              text: "View details".tr,
              color: AppColors.primaryGreen,
            );
          }),

        ],
      ),
    ),
  );
}