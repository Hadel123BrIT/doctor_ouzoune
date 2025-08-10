import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate Your Assistant'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // نجمة التقييم
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < controller.rate.value ? Icons.star : Icons.star_border,
                    size: 40,
                    color: AppColors.primaryGreen,
                  ),
                  onPressed: () {
                    controller.rate.value = index + 1.0;
                  },
                );
              }),
            )),

            const SizedBox(height: 30),

            // حقل الملاحظات
            Text(
              'Add a Note (Optional)'.tr,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.noteController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your feedback here...'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primaryGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // زر التقديم
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.submitRating(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Submit Rating'.tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}