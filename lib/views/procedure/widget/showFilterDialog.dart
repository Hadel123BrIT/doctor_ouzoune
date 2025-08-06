import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../procedure_controller/procedure_controller.dart';

void showFilterDialog(BuildContext context) {
  final ProcedureController controller = Get.find();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Filter Procedures",
          style: TextStyle(fontFamily:'Montserrat'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // حقل اسم الطبيب
              TextField(
                decoration: InputDecoration(
                  labelText: 'Doctor Name',
                  labelStyle: TextStyle(fontFamily: 'Montserrat'),
                ),
                onChanged: (value) => controller.searchQuery.value = value,
              ),

              // حقل اسم العيادة
              TextField(
                decoration: InputDecoration(
                  labelText: 'Clinic Name',
                  labelStyle: TextStyle(fontFamily: 'Montserrat'),
                ),
                onChanged: (value) => controller.clinicNameFilter.value = value,
              ),

              // حقل عنوان العيادة
              TextField(
                decoration: InputDecoration(
                  labelText: 'Clinic Address',
                  labelStyle: TextStyle(fontFamily: 'Montserrat'),
                ),
                onChanged: (value) => controller.clinicAddressFilter.value = value,
              ),

              // حقل عدد المساعدين الأدنى
              TextField(
                decoration: InputDecoration(
                  labelText: 'Min Assistants',
                  labelStyle: TextStyle(fontFamily: 'Montserrat'),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.minAssistants.value = int.parse(value);
                  }
                },
              ),

              // حقل عدد المساعدين الأقصى
              TextField(
                decoration: InputDecoration(
                  labelText: 'Max Assistants',
                  labelStyle: TextStyle(fontFamily: 'Montserrat'),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.maxAssistants.value = int.parse(value);
                  }
                },
              ),

              // حقل تاريخ البداية
              ListTile(
                title: Text(
                  'From Date: ${controller.fromDate.value?.toLocal().toString().split(' ')[0] ?? 'Not selected'}',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    controller.fromDate.value = selectedDate;
                  }
                },
              ),

              // حقل تاريخ النهاية
              ListTile(
                title: Text(
                  'To Date: ${controller.toDate.value?.toLocal().toString().split(' ')[0] ?? 'Not selected'}',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    controller.toDate.value = selectedDate;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.resetFilters();
              Get.back();
            },
            child: Text("Reset",
              style: TextStyle(
                fontFamily:'Montserrat',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel",
              style: TextStyle(
                fontFamily:'Montserrat',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.fetchAllProcedures();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: Text("Apply",
              style: TextStyle(
                fontFamily:'Montserrat',
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}