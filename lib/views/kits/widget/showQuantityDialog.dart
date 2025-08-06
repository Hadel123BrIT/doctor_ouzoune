import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
Future<int?> ShowQuantityDialog(String toolName) async {
  int? selectedQuantity;
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  await Get.dialog(
    AlertDialog(
      title: Text('Enter Quantity for $toolName', style: TextStyle( fontFamily: "Montserrat",color: AppColors.primaryGreen)),
      content: Container(
        width: 200,
        child: TextField(
          controller: _quantityController,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          cursorColor: AppColors.primaryGreen,
          decoration: InputDecoration(
            labelText: 'Quantity',
            labelStyle: TextStyle( fontFamily: "Montserrat",color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.0),
            ),
            hintText: 'Enter desired quantity',
            hintStyle: TextStyle( fontFamily: "Montserrat",),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              selectedQuantity = int.tryParse(value);
            } else {
              selectedQuantity = null;
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: TextStyle( fontFamily: "Montserrat",color: AppColors.primaryGreen)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
          onPressed: () {
            if (_quantityController.text.isNotEmpty) {
              selectedQuantity = int.tryParse(_quantityController.text);
              Get.back();
            }
          },
          child: Text('Confirm', style: TextStyle( fontFamily: "Montserrat",color: Colors.white)),
        ),
      ],
    ),
  );

  _focusNode.dispose();
  return selectedQuantity;
}