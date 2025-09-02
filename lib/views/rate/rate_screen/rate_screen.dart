import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ouzoun/widgets/custom_button.dart';

import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_drawer.dart';
import '../../../core/constants/app_colors.dart';
import '../rate_controller/rate_controller.dart';



class RateScreen extends StatelessWidget {
  RateScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final RateController controller = Get.put(RateController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          toolbarHeight: context.height * 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(context.width * 0.06),
            ),),
            title: Text("Assistance Rating",
                style: Theme.of(context).textTheme.titleSmall),
            backgroundColor: AppColors.primaryGreen,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.width * 0.04),
                  margin: EdgeInsets.only(bottom: context.height * 0.01),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello Doctor,",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: context.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: context.height * 0.01),
                      Text(
                        "On this page you can rate the assistants from 1 to 5 and write your comments about them....",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: context.width * 0.035,
                          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),


                _buildAssistantDropdown(context),

                const SizedBox(height: 30),

                _buildRatingSection(context),

                const SizedBox(height: 15),

                _buildFeedbackSection(context),

                SizedBox(height: 30),
                Obx(() {
                  return controller.isLoading.value
                      ? _buildProgressIndicator(context)
                      : CustomButton(
                    onTap: () {
                      controller.submitRating();
                    },
                    text: 'Submit Rating',
                    color: AppColors.primaryGreen,
                  );
                }),


              ],
            ),
          ),
        );
    }

  Widget _buildAssistantDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Assistant',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.assistantsList.isEmpty) {
            return Center(
              child: Text(
                'No assistants available for rating',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Choose an assistant',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                  ),
                ),
                value: controller.assistantId.value.isEmpty
                    ? null
                    : controller.assistantId.value,
                items: controller.assistantsList.map((assistant) {
                  // تأكد من أن id هو String
                  final assistantId = assistant['id']?.toString() ?? '';
                  final assistantName = assistant['name']?.toString() ?? 'Unknown';

                  return DropdownMenuItem<String>(
                    value: assistantId,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        assistantName,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final assistant = controller.assistantsList.firstWhere(
                          (a) => a['id']?.toString() == value,
                      orElse: () => {'id': value, 'name': 'Unknown'},
                    );
                    controller.selectAssistant(value, assistant['name']?.toString() ?? 'Unknown');
                  }
                },
                padding: const EdgeInsets.symmetric(horizontal: 8),
                icon: const Icon(Icons.arrow_drop_down, size: 30),
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Theme.of(context).colorScheme.background,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      'Rate Your Assistant',
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    ),
    const SizedBox(height: 15),
    Center(
    child: Obx(() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
    return IconButton(
    icon: Icon(
    index < controller.rate.value
    ? Icons.star
        : Icons.star_border,
    size: 40,
    color: AppColors.primaryGreen,
    ),
    onPressed: () => controller.rate.value = index + 1,
    );
    }),
    ))
    ),
     SizedBox(height: 10),
    Center(
    child: Obx(() => Text(
    '${controller.rate.value} ${controller.rate.value == 1 ? 'Star' : 'Stars'}',
    style: TextStyle(
    fontSize: 16,
    fontFamily: 'Montserrat',
    color: Colors.grey[700],
    ),
    )),
    ),
    ],
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a Note (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller.noteController,
          maxLines: 5,
          cursorColor: AppColors.primaryGreen,
          decoration: InputDecoration(
            hintText: 'Write your feedback here...',
            hintStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: AppColors.primaryGreen,
                  width: 2.0),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              strokeWidth: 4,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Submitting Rating...',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}