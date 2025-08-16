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
        // Getsearch(),
      ],
    ),
  );
}