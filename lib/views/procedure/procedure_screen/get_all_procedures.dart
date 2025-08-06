// views/procedures_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/Implant_model.dart';
import '../../../models/assistant_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';
import '../widget/buildProceduresList.dart';
import '../widget/buildSearchAndFilterBar.dart';
import '../widget/showPaginationDialog.dart';


class ProceduresScreen extends StatelessWidget {
  final ProcedureController controller = Get.put(ProcedureController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => showPaginationDialog(context),
            icon: Icon(Icons.tune, color: Colors.white),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("All Procedures",
            style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
        child: Column(
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(context.width * 0.03),
            //   margin: EdgeInsets.only(bottom: context.height * 0.02),
            //   decoration: BoxDecoration(
            //     color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Hello Doctor,",
            //         style: TextStyle(
            //           fontFamily: "Montserrat",
            //           fontSize: context.width * 0.045,
            //           fontWeight: FontWeight.bold,
            //           color: isDarkMode ? Colors.white : Colors.black,
            //         ),
            //       ),
            //       SizedBox(height: context.height * 0.01),
            //       Text(
            //         "This page allows you to see all the transactions you have sent to the admin with their full details. You can also see the details of each transaction individually..",
            //         style: TextStyle(
            //           fontFamily: "Montserrat",
            //           fontSize: context.width * 0.035,
            //           color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            buildSearchAndFilterBar(context),
            Expanded(child: buildProceduresList()),
            Obx(() => Text(
              'page  ${controller.currentPage} - show ${controller.itemsPerPage} element',
              style: TextStyle(
                  fontFamily:'Montserrat',
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

}