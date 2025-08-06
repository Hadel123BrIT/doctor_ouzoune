import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ouzoun/widgets/get_search.dart';

import '../procedure_controller/procedure_controller.dart';

Widget buildSearchAndFilterBar(BuildContext context) {
  final ProcedureController controller = Get.put(ProcedureController());
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  return Padding(
    padding: EdgeInsets.symmetric( vertical: Get.height * 0.02),
    child: Column(
      children: [
        Getsearch(),
        // Row(
        //   children: [
        //     Expanded(
        //       child: Obx(() => DropdownButtonFormField<int>(
        //         value: controller.statusFilter.value,
        //         items: [
        //           DropdownMenuItem(value: 0, child: Text('All Statuses')),
        //           DropdownMenuItem(value: 3, child: Text('Pending')),
        //           DropdownMenuItem(value: 4, child: Text('Completed')),
        //         ],
        //         onChanged: (value) => controller.statusFilter.value = value!,
        //         decoration: InputDecoration(
        //           labelText: 'Status',
        //           border: OutlineInputBorder(),
        //         ),
        //       )),
        //     ),
        //     SizedBox(width: 10),
        //     Obx(() => FilterChip(
        //       label: Text('Main Kits Only'),
        //       selected: controller.showMainKitsOnly.value,
        //       onSelected: (value) {
        //         controller.showMainKitsOnly.value = value;
        //       },
        //     )),
        //   ],
        // ),
      ],
    ),
  );
}