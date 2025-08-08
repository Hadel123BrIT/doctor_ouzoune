import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/views/homePage/homePage_screen/homePage_screen.dart';
import 'package:ouzoun/views/myProfile/myProfile_screen/myProfile_screen.dart';
import '../Core/Services/media_query_service.dart';
import '../Models/draw_item_model.dart';
import '../Routes/app_routes.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_images.dart';
import '../core/services/services.dart';
import '../views/about_us/about_us_screen.dart';
import '../views/setting/setting/setting_screen.dart';
import 'custom_view_item_list.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<DrawItemModel> items=[
    DrawItemModel(text: 'HOMEPAGE', icon: Icons.home, function: (){
      Get.to(HomePageScreen());
    }, ),
    DrawItemModel(text: 'MYPROFILE', icon: Icons.person,function: (){
      Get.to(MyProfileScreen());
    }),
    DrawItemModel(text: 'MYORDER', icon: Icons.receipt_long,function: (){

    }),
    DrawItemModel(text: 'ABOUT US', icon: Icons.info,function: (){
      Get.to(AboutUsScreen());
    }),

    DrawItemModel(text: 'SETTING', icon: Icons.settings,function: (){
      Get.to(SettingsScreen());
    }),

    DrawItemModel(
      text: 'LOGOUT',
      icon: Icons.logout,
      function: () async {
        final authService = Get.find<AuthService>();
        final box = GetStorage();
        final confirm = await Get.dialog(
          AlertDialog(
            title: Text('تأكيد تسجيل الخروج'),
            content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: Text('تسجيل الخروج'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            // 1. تسجيل الخروج من الخادم
            await authService.logout();

            // 2. مسح البيانات المحلية
            await box.erase(); // أو await box.remove('auth_token');

            // 3. إعادة التوجيه لصفحة تسجيل الدخول
            Get.offAllNamed(AppRoutes.login);

            // 4. إظهار رسالة نجاح
            Get.snackbar(
              'تم تسجيل الخروج',
              'تم تسجيل خروجك بنجاح',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryGreen,
              colorText: Colors.white,
            );
          } catch (e) {
            Get.snackbar(
              'خطأ',
              'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      },
    ),

  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    _triggerItemAnimations();
  }

  void _triggerItemAnimations() {
    for (int i = 0; i < items.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          setState(() {
            items[i].animated = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.elasticOut,
              ),
            ),
            child: DrawerHeader(
              child:  Image.asset(
                AppAssets.onboarding3LightAndDarkBackground,
                 scale: 4.5,
              ),
            ),
          ),
          const SizedBox(height: 45),
          CustomViewItemList(items: items),
        ],
      ),
    );
  }
}