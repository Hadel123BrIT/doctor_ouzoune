import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/api_services.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final hasUnreadNotifications = false.obs;
  final unreadCount = 0.obs;
  final ApiServices apiServices = Get.put(ApiServices());
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;


      final response = await apiServices.getCurrentUserNotifications();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print('Notifications response: $responseData');

        if (responseData is Map && responseData.containsKey('notifications')) {
          final List<dynamic> notificationList = responseData['notifications'];

          notifications.assignAll(notificationList.map((n) => {
            'id': n['id'] ?? 0,
            'title': n['title'] ?? 'No title',
            'body': n['body'] ?? 'No message',
            'isRead': n['isRead'] ?? false,
            'createdAt': n['createdAt'] ?? DateTime.now().toString(),
          }).toList());

          checkUnreadNotifications();
          return;
        } else if (responseData is List) {

          notifications.assignAll(responseData.map((n) => {
            'id': n['id'] ?? 0,
            'title': n['title'] ?? 'No title',
            'body': n['body'] ?? 'No message',
            'isRead': n['isRead'] ?? false,
            'createdAt': n['createdAt'] ?? DateTime.now().toString(),
          }).toList());

          checkUnreadNotifications();
          return;
        }
      }


     // _loadDefaultNotifications();

    } catch (e) {
      print('Error loading notifications: $e');
      _loadDefaultNotifications();
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> sendNewNotification({required String title, required String body}) async {
    try {
      final response = await apiServices.sendNotification(title: title, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Notification sent successfully');
        return true;
      } else {
        Get.snackbar('Error', 'Failed to send notification');
        return false;
      }
    } catch (e) {
      print('Error sending notification: $e');
      Get.snackbar('Error', 'Failed to send notification: $e');
      return false;
    }
  }

  void _loadDefaultNotifications() {
    notifications.assignAll([
      {
        'id': 1,
        'title': 'New change',
        'body': "Admin changed the status from send request to decline",
        'isRead': false,
        'createdAt': DateTime.now().subtract(Duration(hours: 2)).toString(),
      },
      {
        'id': 2,
        'title': 'System update',
        'body': "New features have been added to the application",
        'isRead': false,
        'createdAt': DateTime.now().subtract(Duration(hours: 5)).toString(),
      },
      {
        'id': 3,
        'title': 'Reminder',
        'body': "Don't forget to complete your profile",
        'isRead': true,
        'createdAt': DateTime.now().subtract(Duration(days: 1)).toString(),
      },
    ]);
    checkUnreadNotifications();
  }

  void checkUnreadNotifications() {
    final unread = notifications.where((n) => n['isRead'] == false).toList();
    hasUnreadNotifications.value = unread.isNotEmpty;
    unreadCount.value = unread.length;
  }

  void markAsRead(int notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
      checkUnreadNotifications();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    notifications.refresh();
    checkUnreadNotifications();
  }

  void clearAllNotifications() {
    notifications.clear();
    hasUnreadNotifications.value = false;
    unreadCount.value = 0;
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }
}