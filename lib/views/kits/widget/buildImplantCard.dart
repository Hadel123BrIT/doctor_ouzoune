import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/views/kits/Kits_Controller/kits_controller.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import 'buildDetailRow.dart';

Widget BuildImplantCard(BuildContext context, Map<String, dynamic> implant) {
  KitsController controller=Get.put(KitsController());
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final implantId = implant['id']?.toString() ?? UniqueKey().toString();
  return  Container(
    margin: EdgeInsets.symmetric(vertical: context.height * 0.01),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: isDarkMode
              ? Colors.black.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
              width: 1.5,
            ),
          ),
          elevation: 0,
          margin: EdgeInsets.zero,
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(context.width * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: context.width * 0.2,
                      height: context.width * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(implant['image']),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: context.width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            implant['name'],
                            style: Theme.of(context).textTheme.bodySmall
                        ),
                        SizedBox(height: context.height * 0.01),
                        Row(
                          children: [
                            BuildDetailRow('height:', implant['height']),
                            SizedBox(width: 20),
                            BuildDetailRow('width:', implant['width']),
                          ],
                        ),
                        Row(
                          children: [
                            BuildDetailRow('radius:', implant['radius']),
                            SizedBox(width: 20),
                            BuildDetailRow('quantity:', '${implant['quantity']}'),
                          ],
                        ),
                        SizedBox(height: context.height * 0.01),
                      ],
                    ),
                  ],
                ),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  implant['description'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Montserrat'
                  ),
                ),
                SizedBox(height: 12),
                CustomButton(
                    onTap: (){
                      Get.toNamed(AppRoutes.detail_kit, arguments: implant);
                    },
                    text: "View details",
                    color: AppColors.primaryGreen
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 3,
          right: 8,
          child: Transform.scale(
            scale: 1.3,
            child: Obx(() {
              final isSelected = controller.selectedImplants.containsKey(implantId);
              return Checkbox(
                value: isSelected,
                onChanged: (val) {
                  controller.toggleImplantSelection(implantId, implant);
                  controller.selectedImplants.refresh();
                },
                activeColor: AppColors.primaryGreen,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    ),
  );
}
