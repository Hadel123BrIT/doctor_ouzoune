import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPageController extends GetxController{
  late TextEditingController resetPassword;
  late TextEditingController confirmResetPassword;
  late  GlobalKey<FormState>key;
  void sucessPage(){

  }
  void goToChoosingPage(){

  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    resetPassword=TextEditingController();
    confirmResetPassword=TextEditingController();
    key=GlobalKey<FormState>();
  }
}