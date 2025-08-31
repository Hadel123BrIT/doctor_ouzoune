import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../notification_controller/notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,
          color: Colors.white,
        )),
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(MediaQuery.of(context).size.width * 0.06),
          ),
        ),
        title:  Text('Notifications',
            style: Theme.of(context).textTheme.titleSmall,
        ),
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
            icon: const Icon(Icons.refresh,
          color: Colors.white,
            ),
            onPressed: () => controller.refreshNotifications(),
          ),
          Obx(() => controller.notifications.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.mark_email_read,
              color: Colors.white,
            ),
            onPressed: () => controller.markAllAsRead(),
            tooltip: 'Mark all as read',
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
           return Center(
            child: Lottie.asset(
                AppAssets.LoadingAnimation,
                fit: BoxFit.cover,
                repeat: true,
                width: 200,
                height: 200
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No notifications found', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshNotifications(),
                child: ListView.builder(
                  itemCount: controller.groupedNotifications.length,
                  itemBuilder: (context, groupIndex) {
                    final group = controller.groupedNotifications[groupIndex];
                    final date = group['date'] as String;
                    final groupNotifications = group['notifications'] as List;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            controller.formatDate(date),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),


                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: groupNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = groupNotifications[index];
                            return _buildNotificationCard(notification, context);
                          },
                        ),

                      ],
                    );
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
        child: const Icon(Icons.delete, color: Colors.white),
      )
          : const SizedBox.shrink()),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification['read'] ?? false;

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
        leading: Icon(
          isRead ? Icons.notifications_none : Icons.notifications_active,
          color: isRead ? Colors.grey : AppColors.primaryGreen,
          size: 35,
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontSize: 17.5,
            fontFamily: 'Montserrat',
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? Colors.grey[600] : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['body'],
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: isRead ? Colors.grey[500] : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification['createdAt']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () {
          if (!isRead) {
            final NotificationController controller = Get.find();
            controller.markAsRead(notification['id']);
          }
        },
      ),
    );
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void _showClearAllDialog(BuildContext context, NotificationController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete all',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        content: const Text(
          'Do you want to delete all notifications?',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllNotifications();
              Get.back();
              Get.snackbar('Done', 'All notifications deleted');
            },
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}