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
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("Assistance Rating",
            style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Assistant', style: TextStyle(fontSize: 18,
                    fontFamily: 'Montserrat',
                )),
                SizedBox(height: 10),
                if (controller.selectedAssistantName.isNotEmpty)
                  ListTile(
                    title: Text(controller.selectedAssistantName.value),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.assistantsList.isEmpty) {
                    return Center(
                      child: Text(
                        'No assistants available for rating',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.assistantsList.length,
                    itemBuilder: (context, index) {
                      final assistant = controller.assistantsList[index];
                      return Card(
                        child: ListTile(
                          title: Text(assistant['name']),
                          trailing: controller.assistantId.value == assistant['id']
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () => controller.selectAssistant(
                              assistant['id'],
                              assistant['name']
                          ),
                        ),
                      );
                    },
                  );
                }),
                SizedBox(height: 30),
              ],
            )),

            Text('Rate Your Assistant', style: TextStyle(fontSize: 18,
                fontFamily: 'Montserrat'
            )),
            SizedBox(height: 10),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < controller.rate.value ? Icons.star : Icons.star_border,
                    size: 40,
                    color: AppColors.primaryGreen,
                  ),
                  onPressed: () => controller.rate.value = index + 1.0,
                );
              }),
            )),

            // قسم الملاحظات
            SizedBox(height: 30),
            Text('Add a Note (Optional)', style: TextStyle(fontSize: 18,
                fontFamily: 'Montserrat'
            )),
            SizedBox(height: 20),
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
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.0),
                ),
              ),
            ),

            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                controller.isLoading.value ? null : controller.submitRating();
              },
              text: 'Submit Rating',
              color: AppColors.primaryGreen,
            ),

            ],
        ),
      ),
    );
  }
}