import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../Kits_Controller/kits_controller.dart';


Widget buildToolItem(BuildContext context, String implantId, int toolId, String toolName) {
  final KitsController controller = Get.find<KitsController>();

  return Obx(() {
    final toolsList = controller.selectedToolsForImplants[implantId] ?? [];
    final isSelected = toolsList.contains(toolId);
    final isNoToolsSelected = toolsList.contains(-1); // استخدم -1 لتمثيل "No tools"
    final isOtherToolSelected = toolsList.any((tool) => tool != -1);

    if (toolId == -1) {
      return ListTile(
        title: Text(toolName),
        trailing: Checkbox(
          value: isSelected,
          onChanged: isOtherToolSelected
              ? null
              : (value) {
            if (value == true) {
              controller.selectedToolsForImplants[implantId] = [-1];
            } else {
              controller.selectedToolsForImplants[implantId] = [];
            }
            controller.update();
          },
          activeColor: AppColors.primaryGreen,
        ),
      );
    } else {
      return ListTile(
        title: Text(
          toolName,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: isNoToolsSelected
              ? null
              : (value) {
            controller.toggleToolSelection(implantId, toolId);
            if (value == true) {
              controller.selectedToolsForImplants[implantId]?.remove(-1);
            }
            controller.update();
          },
          activeColor: AppColors.primaryGreen,
          checkColor: Colors.white,
        ),
      );
    }
  });
}
