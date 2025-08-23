import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/core/constants/app_colors.dart';

import '../notification_controller/notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final NotificationController controller = Get.put(NotificationController());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(MediaQuery.of(context).size.width * 0.06),
          ),
        ),
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [

          Obx(() => controller.unreadCount.value > 0
              ? Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                controller.unreadCount.value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshNotifications(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('no Notifications found', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(context.width * 0.04),
            //  margin: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(
            //       color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
            //       width: 1,
            //     ),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Hello Doctor,",
            //         style: TextStyle(
            //           fontFamily: "Montserrat",
            //           fontSize: context.width * 0.045,
            //           fontWeight: FontWeight.bold,
            //           color: isDarkMode ? Colors.white : Colors.black,
            //         ),
            //       ),
            //       SizedBox(height: context.height * 0.01),
            //       Text(
            //         "This page allows you to see all notifications on the status changes made by the admin..",
            //         style: TextStyle(
            //           fontFamily: "Montserrat",
            //           fontSize: context.width * 0.035,
            //           color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshNotifications(),
                child: ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return _buildNotificationCard(notification,context);
                  },
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() => controller.notifications.isNotEmpty
          ? FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => _showClearAllDialog(context, controller),
        child: const Icon(Icons.delete,
        color: Colors.white,
        ),
      )
          : const SizedBox.shrink()),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification , BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          width: 1.5,
        ),
      ),
      elevation: 0,
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading: Icon(Icons.notifications_active,
        color: AppColors.primaryGreen,
          size: 35,
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontFamily:'Montserrat',
            fontWeight:  FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['body'],
            style: TextStyle(
               fontFamily:'Montserrat',
              color: Colors.grey,
            ),
            ),
            const SizedBox(height: 4),

          ],
        ),
      ),
    );
  }



  void _showClearAllDialog(BuildContext context, NotificationController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all',
        style: TextStyle(
          fontFamily:'Montserrat',
        ),
        ),
        content: const Text('Do you want delete all Nntifications ',
        style: TextStyle(
          fontFamily:'Montserrat',
        ),
        ),
        actions: [
          TextButton(
            onPressed: () =>Get.back(),
            child: const Text('Cancel',
            style: TextStyle(
              fontFamily:'Montserrat',
              color: Colors.grey
            ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllNotifications();
             Get.back();
              Get.snackbar('done', 'Delete all Notifications');
            },
            child: const Text('confirm',
            style: TextStyle(
              fontFamily:'Montserrat',
              color: AppColors.primaryGreen
            ),
            ),
          ),
        ],
      ),
    );
  }
}