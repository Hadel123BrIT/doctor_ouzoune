// buildEditableProfileItem.dart
import 'package:flutter/material.dart';
import 'package:ouzoun/core/constants/app_colors.dart';

class BuildEditableProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final ValueChanged<String> onChanged;

  const BuildEditableProfileItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColors.primaryGreen,
      controller: TextEditingController(text: value,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primaryGreen,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
            width: 1.0,
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: title,
        labelStyle: TextStyle(
            fontFamily:'Montserrat',
            color: Colors.grey
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}