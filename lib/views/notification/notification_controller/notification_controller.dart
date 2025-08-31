import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_services.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final groupedNotifications = <Map<String, dynamic>>[].obs;
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

        notifications.clear();
        groupedNotifications.clear();

        if (responseData is List) {
          final sortedGroups = List.from(responseData);
          sortedGroups.sort((a, b) {
            final dateA = DateTime.parse(a['createdAt'] ?? '');
            final dateB = DateTime.parse(b['createdAt'] ?? '');
            return dateB.compareTo(dateA);
          });

          for (var group in sortedGroups) {
            if (group is Map<String, dynamic>) {
              final notificationsList = group['notifications'] as List? ?? [];


              notificationsList.sort((a, b) {
                final dateA = DateTime.parse(a['createdAt'] ?? '');
                final dateB = DateTime.parse(b['createdAt'] ?? '');
                return dateB.compareTo(dateA);
              });


              for (var notification in notificationsList) {
                notifications.add({
                  'id': notification['id'] ?? 0,
                  'title': notification['title'] ?? 'No title',
                  'body': notification['body'] ?? 'No message',
                  'read': notification['read'] ?? false,
                  'createdAt': notification['createdAt'] ?? DateTime.now().toString(),
                  'groupDate': group['createdAt']?.toString() ?? '',
                });
              }


              groupedNotifications.add({
                'date': group['createdAt']?.toString() ?? '',
                'notifications': notificationsList,
              });
            }
          }

          checkUnreadNotifications();
          return;
        }

      }


      _loadDefaultNotifications();

    } catch (e) {
      print('Error loading notifications: $e');
      _loadDefaultNotifications();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDefaultNotifications() {

    final now = DateTime.now();
    notifications.assignAll([
      {
        'id': 3,
        'title': 'Reminder',
        'body': "Don't forget to complete your profile",
        'read': true,
        'createdAt': now.subtract(Duration(days: 1)).toString(),
        'groupDate': now.subtract(Duration(days: 1)).toString(),
      },
      {
        'id': 2,
        'title': 'System update',
        'body': "New features have been added to the application",
        'read': false,
        'createdAt': now.subtract(Duration(hours: 5)).toString(),
        'groupDate': now.subtract(Duration(hours: 5)).toString(),
      },
      {
        'id': 1,
        'title': 'New change',
        'body': "Admin changed the status from send request to decline",
        'read': false,
        'createdAt': now.subtract(Duration(hours: 2)).toString(),
        'groupDate': now.subtract(Duration(hours: 2)).toString(),
      },
    ]);


    groupedNotifications.assignAll([
      {
        'date': now.subtract(Duration(days: 1)).toString(),
        'notifications': [
          {
            'id': 3,
            'title': 'Reminder',
            'body': "Don't forget to complete your profile",
            'read': true,
            'createdAt': now.subtract(Duration(days: 1)).toString(),
          },
        ],
      },
      {
        'date': now.subtract(Duration(hours: 5)).toString(),
        'notifications': [
          {
            'id': 2,
            'title': 'System update',
            'body': "New features have been added to the application",
            'read': false,
            'createdAt': now.subtract(Duration(hours: 5)).toString(),
          },
        ],
      },
      {
        'date': now.subtract(Duration(hours: 2)).toString(),
        'notifications': [
          {
            'id': 1,
            'title': 'New change',
            'body': "Admin changed the status from send request to decline",
            'read': false,
            'createdAt': now.subtract(Duration(hours: 2)).toString(),
          },
        ],
      },
    ]);

    checkUnreadNotifications();
  }

  void sortNotificationsDescending() {
    notifications.sort((a, b) {
      final dateA = DateTime.parse(a['createdAt'] ?? '');
      final dateB = DateTime.parse(b['createdAt'] ?? '');
      return dateB.compareTo(dateA);
    });


    groupedNotifications.sort((a, b) {
      final dateA = DateTime.parse(a['date'] ?? '');
      final dateB = DateTime.parse(b['date'] ?? '');
      return dateB.compareTo(dateA);
    });

    for (var group in groupedNotifications) {
      final notificationsList = group['notifications'] as List;
      notificationsList.sort((a, b) {
        final dateA = DateTime.parse(a['createdAt'] ?? '');
        final dateB = DateTime.parse(b['createdAt'] ?? '');
        return dateB.compareTo(dateA);
      });
    }

    notifications.refresh();
    groupedNotifications.refresh();
  }

  void checkUnreadNotifications() {
    final unread = notifications.where((n) => n['read'] == false).toList();
    hasUnreadNotifications.value = unread.isNotEmpty;
    unreadCount.value = unread.length;
  }

  void markAsRead(int notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['read'] = true;
      notifications.refresh();


      for (var group in groupedNotifications) {
        final groupNotifications = group['notifications'] as List;
        final groupIndex = groupNotifications.indexWhere((n) => n['id'] == notificationId);
        if (groupIndex != -1) {
          groupNotifications[groupIndex]['read'] = true;
          break;
        }
      }
      groupedNotifications.refresh();

      checkUnreadNotifications();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification['read'] = true;
    }
    notifications.refresh();

    for (var group in groupedNotifications) {
      final groupNotifications = group['notifications'] as List;
      for (var notification in groupNotifications) {
        notification['read'] = true;
      }
    }
    groupedNotifications.refresh();

    checkUnreadNotifications();
  }

  void clearAllNotifications() {
    notifications.clear();
    groupedNotifications.clear();
    hasUnreadNotifications.value = false;
    unreadCount.value = 0;
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }


  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, MMMM d, y').format(date);
    } catch (e) {
      return dateString;
    }
  }


  String formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}