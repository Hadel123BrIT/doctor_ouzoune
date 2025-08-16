import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';
import '../procedure_screen/procedure_detail_screen.dart';

Widget buildProcedureCard(Procedure procedure, BuildContext context) {
  final controller = Get.find<ProcedureController>();
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  if (procedure == null) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Invalid procedure data', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  return Card(
    color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.width * 0.025),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700] ?? Colors.grey : Colors.grey[400] ?? Colors.grey,
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
              ' Doctor : ${procedure.doctor?.userName ?? 'No doctor assigned'}',
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15,
              )
          ),
          SizedBox(height: 8),
          Text(
            'Date: ${procedure.date != null ? DateFormat('yyyy-MM-dd').format(procedure.date!) : 'N/A'} - Time: ${procedure.date != null ? DateFormat('HH:mm').format(procedure.date!) : 'N/A'}',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
              'Number of Assistants: ${procedure.numberOfAssistants ?? 0}',
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15,
              )
          ),

          SizedBox(height: 16),
          CustomButton(
            onTap: () async {
              try {
                if (procedure != null) {
                  final controller = Get.find<ProcedureController>();
                  await controller.fetchProcedureDetails(procedure.id!);
                  if (controller.selectedProcedure.value != null) {
                    Get.to(() => ProcedureDetailScreen(procedure: controller.selectedProcedure.value));
                  } else {
                    Get.snackbar('Error'.tr, 'Procedure details not available'.tr);
                  }
                }
              } catch (e) {
                Get.snackbar('Error'.tr, 'Failed to load details: ${e.toString()}'.tr);
              }
            },
            text: "View details".tr,
            color: AppColors.primaryGreen,
          ),
        ],
      ),
    ),
  );
}