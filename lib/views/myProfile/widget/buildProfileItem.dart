
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';

Widget buildProfileItem(BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: context.height * 0.02),
    padding: EdgeInsets.all(context.width * 0.04),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryGreen,
          size: context.width * 0.06,
        ),
        SizedBox(width: context.width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: context.height * 0.005),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}