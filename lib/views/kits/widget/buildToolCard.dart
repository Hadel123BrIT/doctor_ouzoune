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
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryGreen.withOpacity(0.1),
              ),
              child:  (tool.imagePath != null && tool.imagePath!.isNotEmpty)?Image.network(
                  tool.imagePath!,):    Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color:AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name ?? 'Unnamed Tool',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      BuildDetailItem(context, "Length", "${tool.width}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Width", "${tool.width}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Height", "${tool.height}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "qun", "${tool.quantity}", takeFirstDigit: true)
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  selectedQuantity > 0 ? 'Qty: $selectedQuantity' : 'Add',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(height: context.height * 0.01),
                GestureDetector(
                  onTap: () async {
                    final quantity = await ShowQuantityDialog(tool.name ?? 'Tool');
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
                    child: Icon(
                      selectedQuantity > 0 ? Icons.edit : Icons.add,
                      color: Colors.white,
                    ),
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