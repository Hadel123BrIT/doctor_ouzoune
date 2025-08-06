import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Routes/app_routes.dart';

class CheckEmailController extends GetxController
{
  late TextEditingController checkEmail;
 late GlobalKey<FormState>keyForm;

 void goToVrefiy(){
   Get.toNamed(AppRoutes.code);
 }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkEmail=TextEditingController();
    keyForm=GlobalKey<FormState>();
  }
}