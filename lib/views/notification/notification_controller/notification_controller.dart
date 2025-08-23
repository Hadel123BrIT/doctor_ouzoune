import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/api_services.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final hasUnreadNotifications = false.obs;
  final unreadCount = 0.obs;
  final ApiServices apiServices = Get.put(ApiServices());


  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final String? deviceToken = GetStorage().read('device_token');
      final String? authToken = GetStorage().read('auth_token');

      if (deviceToken == null || authToken == null) {
        _loadDefaultNotifications();
        return;
      }


      final response = await apiServices.getCurrentUserNotifications();

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map && responseData.containsKey('notifications')) {
          final List<dynamic> notificationList = responseData['notifications'];

          notifications.assignAll(notificationList.map((n) => {
            'id': n['id'] ?? 0,
            'title': n['title'] ?? 'no title',
            'body': n['body'] ?? 'no messages',

          }).toList());

          checkUnreadNotifications();
          return;
        }
      }

      _loadDefaultNotifications();

    } catch (e) {
      print('Error loading notifications: $e');
      _loadDefaultNotifications();
    }
  }

  void _loadDefaultNotifications() {
    notifications.assignAll([
      {
        'id': 1,
        'title': 'new change',
        'body':"Admin change the status from send request to decline",

      },
      {
        'id': 2,
        'title': 'new change',
        'body': "Admin change the status from send request to decline",

      },
      {
        'id': 3,
        'title': 'new change',
        'body': "Admin change the status from send request to decline",

      },
    ]);
    checkUnreadNotifications();
  }

  void checkUnreadNotifications() {
    final unread = notifications.where((n) => n['isRead'] == false).toList();
    hasUnreadNotifications.value = unread.isNotEmpty;
    unreadCount.value = unread.length;
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