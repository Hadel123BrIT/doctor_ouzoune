import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/additionalTool_model.dart';
import 'buildDetailItem.dart';
import 'showQuantityDialog.dart';

class BuildToolCard extends StatelessWidget {
  final AdditionalTool tool;
  final int selectedQuantity;
  final Function(int) onQuantitySelected;

  const BuildToolCard({
    required this.tool,
    required this.selectedQuantity,
    required this.onQuantitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color:AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                    tool.name ?? 'Unnamed Tool',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      BuildDetailItem(context, "Length", "${tool.width}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Width", "${tool.width}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Height", "${tool.height}"),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  selectedQuantity > 0 ? 'Qty: $selectedQuantity' : 'Add',
                  style: TextStyle(color: AppColors.primaryGreen,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(height: context.height * 0.01),
                GestureDetector(
                  onTap: () async {
                    final quantity = await ShowQuantityDialog( tool.name ?? 'Tool');
                    if (quantity != null) {
                      onQuantitySelected(quantity);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreen,
                    ),
                    padding: EdgeInsets.all(context.width * 0.02),
                    child: Icon(selectedQuantity > 0 ? Icons.edit : Icons.add),

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}