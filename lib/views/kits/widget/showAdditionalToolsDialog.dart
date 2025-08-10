import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/additionalTool_model.dart';
import '../Kits_Controller/kits_controller.dart';

void showSelectedToolsDialog(List<AdditionalTool> tools) {
  Get.dialog(
    AlertDialog(
      content: Column(
        children: tools.map((tool) => ListTile(
          leading: Text("x${tool.quantity}"),
          title: Text(tool.name ?? 'No Name'),
        )).toList(),
      ),
    ),
  );
}