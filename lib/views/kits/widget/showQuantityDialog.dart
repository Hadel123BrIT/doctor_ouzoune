import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
Future<int?> ShowQuantityDialog(String toolName, {int maxQuantity = 999}) async {
  final quantityController = TextEditingController();
  int? selectedQuantity;

  await Get.dialog(
    AlertDialog(
      title: Text("Select Quantity", style: TextStyle(fontFamily: 'Montserrat')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Available: $maxQuantity", style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.grey[600],
          )),
          SizedBox(height: 10),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter quantity (1-$maxQuantity)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                final entered = int.tryParse(value) ?? 0;
                if (entered > maxQuantity) {
                  quantityController.text = maxQuantity.toString();
                  quantityController.selection = TextSelection.collapsed(
                    offset: quantityController.text.length,
                  );
                }
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel", style: TextStyle(fontFamily: 'Montserrat')),
        ),
        ElevatedButton(
          onPressed: () {
            if (quantityController.text.isNotEmpty) {
              final quantity = int.parse(quantityController.text);
              if (quantity > 0 && quantity <= maxQuantity) {
                selectedQuantity = quantity;
                Get.back(result: quantity);
              } else {
                Get.snackbar(
                  "Error",
                  "Please enter a valid quantity (1->$maxQuantity)",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            }
          },
          child: Text("Confirm", style: TextStyle(fontFamily: 'Montserrat')),
        ),
      ],
    ),
  );

  return selectedQuantity;
}