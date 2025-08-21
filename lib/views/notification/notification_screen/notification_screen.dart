import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import '../notification_controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
        actions: [
          Obx(() => controller.hasUnreadNotifications.value
              ? IconButton(
            icon: Icon(Icons.mark_email_read, color: Colors.white),
            onPressed: controller.markAllAsRead,
            tooltip: 'as reader',
          )
              : SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyState(context);
        }
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildNotificationsList(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            'no Notifications found',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'here all the Notifications',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'latest Notifications',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          TextButton(
            onPressed: controller.clearAllNotifications,
            child: Text(
              'Delete All',
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

  Widget _buildNotificationsList(BuildContext context) {
    return ListView.builder(
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return _buildNotificationItem(context, notification);
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteNotification(notification['id']),
      child: InkWell(
        onTap: () {
          controller.markAsRead(notification['id']);
          _handleNotificationTap(notification);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isRead
                ? Theme.of(context).cardColor
                : AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead ? Colors.grey[300]! : AppColors.primaryGreen,
              width: 1,
            ),
          ),
          child: ListTile(
            leading: _getNotificationIcon(type),
            title: Text(
              notification['title'],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['body'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification['time'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            trailing: !isRead
                ? CircleAvatar(
              radius: 4,
              backgroundColor: AppColors.primaryGreen,
            )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'appointment':
        icon = Icons.calendar_today;
        color = Colors.blue;
        break;
      case 'reminder':
        icon = Icons.alarm;
        color = Colors.orange;
        break;
      case 'message':
        icon = Icons.message;
        color = Colors.green;
        break;
      default:
        icon = Icons.notifications;
        color = AppColors.primaryGreen;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];

    switch (type) {
      case 'appointment':
        Get.toNamed('/appointments');
        break;
      case 'reminder':
        Get.toNamed('/reminders');
        break;
      case 'message':
        Get.toNamed('/messages');
        break;
      default:
        Get.toNamed('/home');
    }
  }
}