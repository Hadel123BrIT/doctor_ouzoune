import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../Kits_Controller/kits_controller.dart';

void showSelectedToolsDialog() {
  final KitsController controller = Get.put(KitsController());
  Get.defaultDialog(
    title: "Selected Additional Tools",
    content: Obx(() => Column(
      children: [
        if (controller.selectedAdditionalTools.isEmpty)
          Text("No tools selected"),
        ...controller.selectedAdditionalTools.map((tool) => ListTile(
          leading: Text("x${tool['quantity']}", style: TextStyle(fontSize: 15)),
          title: Text(tool['name']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final index = controller.additionalTools.indexWhere(
                      (item) => item['name'] == tool['name']);
              if (index != -1) {
                controller.updateAdditionalToolQuantity(index, 0);
              }
            },
          ),
        )),
      ],
    )),
    confirm: TextButton(
      child: Text("OK", style: TextStyle(color: AppColors.primaryGreen)),
      onPressed: () => Get.back(),
    ),
  );
}