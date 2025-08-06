import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget BuildDetailItem(BuildContext context, String title, dynamic value, {bool isNumeric = false}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Montserrat",
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ],
  );
}