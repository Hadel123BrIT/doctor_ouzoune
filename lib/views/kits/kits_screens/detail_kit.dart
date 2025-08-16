import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import 'package:ouzoun/models/additionalTool_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/Implant_model.dart';
import '../../../models/kit_model.dart';
import '../../../widgets/custom_button.dart';
import '../Kits_Controller/kits_controller.dart';
import '../widget/buildSpecItem.dart';

class ImplantDetailScreen extends StatelessWidget {
  final Implant implant;
  final KitsController controller = Get.find<KitsController>();

  ImplantDetailScreen({super.key, required this.implant});

  @override
  Widget build(BuildContext context) {
    final implantId = implant.id.toString();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final tools = controller.getKitTools();
      final toolNames = controller.getKitToolNames();

      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
              // Header with green background
              Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: context.width * 0.5,
                height: context.height * 0.16,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(context.width * 0.2),
                  ),
                ),
              ),
              ),
              // Main content
              Padding(
                padding: EdgeInsets.all(context.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Implant image and name
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: context.width * 0.4,
                            height: context.width * 0.4,
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ],
                              image: DecorationImage(
                                image: AssetImage(implant.imagePath!),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: context.height * 0.02),
                          Text(
                            controller.getImplantName(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: context.height * 0.01),
                        ],
                      ),
                    ),

                    // Specifications section
                    _buildSection(
                      context,
                      title: "Specifications",
                      children: [
                        BuildSpecItem(context, "Height", implant.height),
                        BuildSpecItem(context, "Width", implant.width),
                        BuildSpecItem(context, "Radius", implant.radius),
                      ],
                    ),

                    // Brand and Quantity section
                    _buildSection(
                      context,
                      title: "Brand and Quantity",
                      children: [
                        BuildSpecItem(context, "Brand", implant.brand),
                        BuildSpecItem(context, "Quantity", '${implant.quantity}'),
                      ],
                    ),

                    // Description section
                    _buildSection(
                      context,
                      title: "Description",
                      children: [
                        Text(
                          implant.description!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),

                    // Required Tools section
                    _buildSection(
                      context,
                      title: "Required Tools",
                      children: controller.isLoading.value
                          ? [Center(child: CircularProgressIndicator())]
                          : _buildKitToolsList(toolNames),
                    ),

                    // Add to Cart button
                    SizedBox(height: context.height * 0.04),
                    Center(
                      child: CustomButton(
                        onTap: () {
                          final hasSelectedTools = (controller.selectedToolsForImplants[implantId]?.isNotEmpty ?? false);

                          if (hasSelectedTools) {
                            final result = {
                              'implantId': implantId,
                              'implantName': controller.getImplantName(),
                              'selectedTools': controller.selectedToolsForImplants[implantId] ?? [],
                            };
                            Get.back(result: result);
                            Get.snackbar("Added", "${controller.getImplantName()} added to cart");
                          } else {
                            Get.snackbar("Warning", "Please select at least one option");
                          }
                        },
                        text: 'Add to Cart',
                        color: AppColors.primaryGreen,
                      ),
                    )
                  ],
                ),
              ),

              // Footer with green background
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: context.width * 0.5,
                  height: context.height * 0.16,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(context.width * 0.2),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      children: [
        SizedBox(height: context.height * 0.03),
        Container(
          padding: EdgeInsets.all(context.width * 0.04),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: context.height * 0.01),
              Divider(color: AppColors.primaryGreen),
              SizedBox(height: context.height * 0.01),
              ...children,
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildKitToolsList(List<String?> toolNames) {
    if (toolNames.isEmpty || (toolNames.length == 1 && toolNames.first == 'No tools')) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'No tools required for this implant',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ];
    }

    return toolNames.map((toolName) {
      if (toolName == null || toolName.isEmpty) return SizedBox();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                toolName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}