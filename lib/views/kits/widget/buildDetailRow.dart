import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget BuildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat'
          ),
        ),
        SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat'
          ),
        ),
      ],
    ),
  );
}