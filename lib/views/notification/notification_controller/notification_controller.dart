import 'package:get/get.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final hasUnreadNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {

    notifications.assignAll([
      {
        'id': 1,
        'title': 'موعد جديد',
        'body': 'لديك موعد مع الدكتور أحمد في 3:00 مساءً',
        'time': 'منذ 5 دقائق',
        'isRead': false,
        'type': 'appointment',
      },
      {
        'id': 2,
        'title': 'تذكير',
        'body': 'لا تنسى تحضير الأدوات للعملية الجراحية',
        'time': 'منذ ساعة',
        'isRead': true,
        'type': 'reminder',
      },
      {
        'id': 3,
        'title': 'رسالة جديدة',
        'body': 'لديك رسالة من الممرضة سارة',
        'time': 'منذ يوم',
        'isRead': false,
        'type': 'message',
      },
    ]);

    checkUnreadNotifications();
  }

  void checkUnreadNotifications() {
    hasUnreadNotifications.value = notifications.any((notification) => !notification['isRead']);
  }

  void markAsRead(int id) {
    final index = notifications.indexWhere((notif) => notif['id'] == id);
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
    hasUnreadNotifications.value = false;
  }

  void deleteNotification(int id) {
    notifications.removeWhere((notif) => notif['id'] == id);
    checkUnreadNotifications();
  }

  void clearAllNotifications() {
    notifications.clear();
    hasUnreadNotifications.value = false;
  }
}