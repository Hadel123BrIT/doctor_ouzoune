import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ouzoun/views/homePage/homePage_screen/homePage_screen.dart';
import '../Core/Services/media_query_service.dart';
import '../Models/draw_item_model.dart';
import '../core/constants/app_images.dart';
import '../views/about_us/about_us_screen.dart';
import '../views/setting/setting_screen/setting_screen.dart';
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
    // Get.to(DoctorProfilePage());
    }),
    DrawItemModel(text: 'MYORDER', icon: Icons.receipt_long,function: (){
      // Get.to(DoctorProfilePage());
    }),
    DrawItemModel(text: 'ABOUT US', icon: Icons.info,function: (){
      Get.to(AboutUsScreen());
    }),

    DrawItemModel(text: 'SETTING', icon: Icons.settings,function: (){
      Get.to(SettingsScreen());
    }),

    DrawItemModel(text: 'LOGOUT', icon: Icons.logout,function: ()async{

  }),

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