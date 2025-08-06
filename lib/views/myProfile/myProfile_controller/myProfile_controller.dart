import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MyProfileController extends GetxController{
  final nameController = TextEditingController(text: 'Dr.Ahmed Mohamad');
  final emailController = TextEditingController(text: 'doctor@example.com');
  final passwordController = TextEditingController(text: '•••••••••••');
  final locationController = TextEditingController(text: 'Damascus , Syria');
  final phoneController = TextEditingController(text: '+963 123 456 789');
  final clinicNameController = TextEditingController(text: 'Ahmed clinic');
  final addressController = TextEditingController(text: 'AlTal _ AlBahrah');
  }
