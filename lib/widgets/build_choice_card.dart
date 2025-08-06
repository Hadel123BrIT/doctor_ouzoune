// widgets/choice_card.dart
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class BuildChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final double height;

  const BuildChoiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.onTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding:EdgeInsets.all(10),
             alignment:Alignment.center,
            height: 175,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 45,
                    color: textColor),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign:TextAlign.center,
                  style:Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign:TextAlign.center,
              style:Theme.of(context).textTheme.headlineMedium,
            ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}