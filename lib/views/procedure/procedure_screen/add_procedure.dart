import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/routes/app_routes.dart';
import 'package:ouzoun/views/procedure/procedure_controller/procedure_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../kits/Kits_Controller/kits_controller.dart';
import '../widget/buildProcedureHelper.dart';

class AddProcedure extends StatelessWidget {
  AddProcedure({super.key});
  final controller = Get.put(ProcedureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,
        color: Colors.white,
        )),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("Add New Procedure ",
            style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Get.width * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // buildPatientNameField(context),
            // SizedBox(height: Get.height * 0.03),
            buildNeedsAssistanceDropdown(context),
            SizedBox(height: Get.height * 0.03),
            buildAssistantsCountDropdown(context),
            controller.needsAssistance.value?
              SizedBox(height: Get.height * 0.04):
            SizedBox(height: Get.height * 0.03),
            buildProcedureTypeDropdown(context),
            SizedBox(height: Get.height * 0.03),
            buildDateTimeSelectionRow(context),
            SizedBox(height: Get.height * 0.03),
            buildKitsToolsButtonsRow(context),
            SizedBox(height: Get.height * 0.05),
            buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

}