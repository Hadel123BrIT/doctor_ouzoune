import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../kits/kits_screens/detail_kit.dart';
import '../../kits/kits_screens/implant_kits.dart';
import '../../kits/kits_screens/surgical_kits.dart';
import '../procedure_controller/procedure_controller.dart';
import '../../kits/Kits_Controller/kits_controller.dart';

Widget buildPatientNameField(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(ProcedureController());
  return TextField(
    cursorColor: Colors.grey,
    controller: controller.patientNameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      hintText: 'Patient Name',
      hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: isDark ? Colors.white : Colors.black,
    ),
  );
}

Widget buildNeedsAssistanceDropdown(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(ProcedureController());
  return Obx(() => DropdownButtonFormField<bool>(
    items: [
      DropdownMenuItem(
        value: true,
        child: Text('Yes', style: Theme.of(context).textTheme.headlineSmall),
      ),
      DropdownMenuItem(
        value: false,
        child: Text('No', style: Theme.of(context).textTheme.headlineSmall),
      ),
    ],
    onChanged: (value) => controller.needsAssistance.value = value!,
    value: controller.needsAssistance.value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      labelText: 'Needed Assistance',
      labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),));
}

Widget buildAssistantsCountDropdown(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(ProcedureController());
  return Obx(() => controller.needsAssistance.value
      ? DropdownButtonFormField<int>(
    items: List.generate(5, (index) => index + 1)
        .map((count) => DropdownMenuItem(
      value: count,
      child: Text(count.toString(),
          style: Theme.of(context).textTheme.headlineSmall),
    ))
        .toList(),
    onChanged: (value) => controller.assistantsCount.value = value!,
    value: controller.assistantsCount.value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      labelText: 'Number rof Assistance',
      labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),
  )
      : const SizedBox.shrink());
}

Widget buildProcedureTypeDropdown(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(ProcedureController());
  return Obx(() => DropdownButtonFormField<int>(
    items: [
      DropdownMenuItem(
        value: 1, // medical supplies
        child: Text(
          'Medical Supplies',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      DropdownMenuItem(
        value: 2, // surgical operation
        child: Text(
          'Surgical Operation',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    ],
    onChanged: (value) => controller.procedureType.value = value!,
    value: controller.procedureType.value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      labelText: 'Procedure Type',
      labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),
  ));
}

Widget buildDateTimeSelectionRow(BuildContext context) {
  final controller = Get.put(ProcedureController());
  return Row(
    children: [
      Expanded(
        child: Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          onPressed: () => controller.selectDate(context),
          child: Text(
            controller.procedureDate.value == null
                ? 'Select Date'
                : ' ${controller.procedureDate.value!.toLocal().toString().split(' ')[0]}',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
        )),
      ),
      SizedBox(width: Get.width * 0.03),
      Expanded(
        child: Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => controller.selectTime(context),
          child: Text(
            controller.procedureTime.value == null
                ? 'Select Time'
                : 'Time : ${controller.procedureTime.value!.format(context)}',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
        )),
      ),
    ],
  );
}

Widget buildKitsToolsButtonsRow(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final KitsController controller = Get.put(KitsController());

  return Column(
    children: [
      //Surgical kits
    Container(
    width: double.infinity,
    constraints: BoxConstraints(minHeight: 200),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mandatory Surgical Tools',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10),
          ...controller.surgicalKits.map((tool) => ListTile(
            title: Text(
              tool['name'],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          )).toList(),
        ],
      ),
    ),
  ),


    SizedBox(height: 20),


    //Full implant Kits
      Obx(() => Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: controller.selectedImplants.isEmpty
            ? TextButton(
          onPressed: () async {
            await Get.to(() => Implantkits());

          },
          child: Text('Tap to choose Full Implant Kits',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        )
            : _buildSelectedImplantsList(context, controller.selectedImplants),
      )),


    SizedBox(height: 20),


    //Additional tools
      Obx(() => Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: controller.selectedTools.isEmpty
            ? ElevatedButton(
          onPressed: () async {
            await Get.toNamed(AppRoutes.additional_kit);
            controller.updateToolsSelection();
          },
          child: Text(
            'Tap to choose Additional Tools',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontFamily: 'Montserrat',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Theme.of(context).cardColor : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
            : Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: controller.selectedTools.length,
                  itemBuilder: (context, index) {
                    final tool = controller.selectedTools[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tool['name'],
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            'x ${tool['quantity']}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () async {
                    await Get.toNamed(AppRoutes.additional_kit);
                    controller.updateToolsSelection();
                  },
                  child: Text(
                    'Edit Selection',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),


    SizedBox(height: 20),



    //Implants or Tools
      Obx(() {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: controller.selectedPartialImplants.isEmpty
              ? Center(
             child:  TextButton(
               onPressed: () async {
                 final selectedImplant = await showDialog<Map<String, dynamic>>(
                   context: context,
                   builder: (context) => AlertDialog(
                     title: Text("Select Implant"),
                     content: SizedBox(
                       width: double.maxFinite,
                       child: ListView.builder(
                         shrinkWrap: true,
                         itemCount: controller.implants.length,
                         itemBuilder: (context, index) {
                           final implant = controller.implants[index];
                           return ListTile(
                             title: Text(implant['name'],
                               style: TextStyle(
                                 fontFamily: 'Montserrat',
                                 fontSize: 14,
                                 color: Colors.grey,
                               ),
                             ),
                             onTap: () => Get.back(result: implant),
                           );
                         },
                       ),
                     ),
                   ),
                 );

                 if (selectedImplant != null) {
                   final result = await Get.to(
                         () => ImplantDetailScreen(implant: selectedImplant),
                   );
                   if (result != null && result is Map) {
                     controller.addPartialImplant(
                       result['implantId'].toString(),
                       result['implantName'],
                       tools: result['selectedTools']?.cast<String>() ?? [],
                     );
                   }
                 }
               },
               child: Text('Tap to choose Partial Implants / Tools',
                 style: TextStyle(
                   fontFamily: 'Montserrat',
                   fontSize: 14,
                   color: Colors.grey,
                 ),
               ),
             )
          )
              : _buildPartialImplantsList(context, controller.selectedPartialImplants),
        );
      })
    ],


  );
}

Widget buildSubmitButton(BuildContext context) {
  final controller = Get.put(ProcedureController());
  return CustomButton(
      onTap: (){
        controller.postProcedure();
        Get.snackbar(
          'Processing',
          'Your request is being processed...',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
  }, text: 'Confirm Procedure', color: AppColors.primaryGreen);

}

Widget _buildSelectedImplantsList(BuildContext context, RxMap<String, Map<String, dynamic>> implants) {
  final controller = Get.find<KitsController>();
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Selected Full Implant Kits:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        ...implants.entries.map((entry) => Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              entry.value['name']?.toString() ?? 'Unknown Implant',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.toggleImplantSelection(entry.key, entry.value),
            ),
          ),
        )).toList(),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            await Get.to(() => Implantkits());
          },
          child: Text(
            'Edit Selection',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPartialImplantsList(BuildContext context, List<Map<String, dynamic>> implants) {
  final controller = Get.find<KitsController>();

  return ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: 200,
      maxHeight: MediaQuery.of(context).size.height * 0.4,
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Selected Partial Implants with Tools',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: controller.selectedPartialImplants.length,
            itemBuilder: (context, index) {
              final implant = controller.selectedPartialImplants[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    implant['implantName'] ?? 'Unknown Implant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (implant['tools'] != null && implant['tools'].isNotEmpty)
                        Text(
                          'Tools: ${implant['tools'].join(', ')}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'Montserrat',
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.removePartialImplant(implant['implantId']),
                  ),
                ),
              );
            },
          )),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            onPressed: () async {
              final selectedImplant = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Select Implant"),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.implants.length,
                      itemBuilder: (context, index) {
                        final implant = controller.implants[index];
                        return ListTile(
                          title: Text(implant['name']),
                          onTap: () => Navigator.pop(context, implant),
                        );
                      },
                    ),
                  ),
                ),
              );

              if (selectedImplant != null) {
                final result = await Get.to(
                      () => ImplantDetailScreen(implant: selectedImplant),
                );
                if (result != null && result is Map) {
                  controller.addPartialImplant(
                    result['implantId'].toString(),
                    result['implantName'],
                    tools: result['selectedTools']?.cast<String>() ?? [],
                  );
                }
              }
            },
            child: Text(
              'Add Another',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}