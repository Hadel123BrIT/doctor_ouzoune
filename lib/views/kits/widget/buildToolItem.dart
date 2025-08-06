import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../Kits_Controller/kits_controller.dart';

Widget buildToolItem(BuildContext context, String implantId, String toolName) {
  final KitsController controller = Get.put(KitsController());
  return Obx(() {
    final toolsList = controller.selectedToolsForImplants[implantId] ?? [];
    final isSelected = toolsList.contains(toolName);
    final isNoToolsSelected = toolsList.contains('No tools');
    final isOtherToolSelected = toolsList.any((tool) => tool != 'No tools');

    if (toolName == 'No tools') {
      return ListTile(
        title: Text(toolName),
        trailing: Checkbox(
          value: isSelected,
          onChanged: isOtherToolSelected
              ? null
              : (value) {
            if (value == true) {
              controller.selectedToolsForImplants[implantId] = ['No tools'];
            } else {
              controller.selectedToolsForImplants[implantId] = [];
            }
            controller.selectedToolsForImplants.refresh();
          },
          activeColor: AppColors.primaryGreen,
        ),
      );
    }
    else {
      return ListTile(
        title: Text(toolName,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: isNoToolsSelected
              ? null
              : (value) {
            controller.toggleToolForImplant(implantId, toolName);
            if (value == true) {
              controller.selectedToolsForImplants[implantId]?.remove('No tools');
            }
            controller.selectedToolsForImplants.refresh();
          },
          activeColor: AppColors.primaryGreen,
          checkColor: Colors.white,
        ),
      );
    }
  });
}
