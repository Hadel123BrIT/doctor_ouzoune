import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/views/doctor_choices/doctor_choices_screens/first_page_choices.dart';
import 'package:ouzoun/views/homePage/homePage_screen/homePage_screen.dart';
import 'package:ouzoun/views/splash/splash_screens/splash_screen.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'core/constants/theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        getPages: AppPages.pages,
        theme:lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
       home: SplashScreen()
       //home: HomePageScreen(),

    );
  }

}


