import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../Core/Services/media_query_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/services.dart';
import '../../../login/login_screen.dart';
import '../../../myProfile/myProfile_controller/myProfile_controller.dart';
import '../setting_controller.dart';

final _controller = Get.put(MyProfileController());
SettingController controller = Get.put(SettingController());

Widget buildAccountCard(BuildContext context) {
  return Card(
    color: AppColors.primaryGreen,
    margin: EdgeInsets.only(bottom: context.height * 0.03),
    child: Padding(
      padding: EdgeInsets.all(context.width * 0.04),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.width * 0.1,
            backgroundColor: AppColors.lightGreen,
            child:  Icon(Icons.person,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: context.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  _controller.userName.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  )
              ),
              Text(
                _controller.email.value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildSettingsSection(
    BuildContext context, {
      required String title,
      required IconData icon,
      required List<Widget> children,
    }) {return Card(
  margin: EdgeInsets.only(bottom: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      Divider(height: 1),
      ...children,
    ],
  ),
);}

Widget buildSettingItem(
    BuildContext context, {
      required IconData icon,
      required String title,
      String? value,
      Widget? trailing,
      Function()? onTap,
    }) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primaryGreen),
    title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    subtitle: value != null
        ? Text(value, style: Theme.of(context).textTheme.titleMedium)
        : null,
    trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryGreen),
    onTap: onTap,
  );
}

void changeLanguage(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("choose languages",
          style:  Theme.of(context).textTheme.titleMedium
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("English",
                style:  Theme.of(context).textTheme.headlineSmall
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text("English",
                style:  Theme.of(context).textTheme.headlineSmall
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}

void changeTheme(BuildContext context) {
  controller.toggleTheme();
}

Future<void> logout(BuildContext context) async {
  final box = GetStorage();

  final confirm = await Get.dialog(
    AlertDialog(
      title: Center(
        child: Text(
          'Confirm logout',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: TextStyle(
          fontFamily: 'Montserrat',
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
          ),
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    ),
  );

  if (confirm == true) {
    try {
      AuthService authService;
      try {
        authService = Get.find<AuthService>();
        await authService.logout();
      } catch (e) {
        print('AuthService not found, proceeding with local logout: $e');
      }
      await box.erase();
      Get.offAll(() => LoginScreen());

      Get.snackbar(
        'Success',
        'You have been successfully logged out.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print('Logout error: $e');
      Get.snackbar(
        'Error',
        'An error occurred while logging out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}