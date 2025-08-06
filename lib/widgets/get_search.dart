import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ouzoun/core/constants/app_colors.dart';

import '../views/procedure/procedure_controller/procedure_controller.dart';
import '../views/procedure/widget/showFilterDialog.dart';
class Getsearch extends StatelessWidget {
  const Getsearch({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: context.height * 0.06,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            ),
            child: TextField(
              onChanged: (value) {
                final controller = Get.find<ProcedureController>();
                controller.searchQuery.value = value;
                controller.fetchAllProcedures();
              },
              cursorColor: AppColors.primaryGreen,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "search ",
                hintStyle:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: context.width * 0.05),
        Container(
          height: context.height * 0.06,
          width: context.width * 0.1,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          ),
          child: Center(
            child: IconButton(
              onPressed: (){
                showFilterDialog(context);
              },
              icon: Icon(Icons.filter_list_sharp,
              color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
