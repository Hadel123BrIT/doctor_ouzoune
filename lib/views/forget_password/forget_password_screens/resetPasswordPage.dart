import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_button.dart';
import '../../../Widgets/custom_text_form_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_text_form_field.dart' hide CustomTextFormField;
import '../forget_password_controller/resetpagecontroller.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResetPageController controller=Get.put(ResetPageController());
    return  Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background ,
      body:SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:context.height*0.15,horizontal:context.width*0.06),
          child:Container(
            alignment: Alignment.center,
            child: Column(children: [
              Icon(FontAwesomeIcons.key,color:AppColors.primaryGreen, size: context.width * 0.2,),
              SizedBox(height: context.height * 0.03),
              Text("Reset Password",textAlign: TextAlign.center,style:Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: context.height * 0.02),
              Text("Please Reset your Password to Access\nOuzoun App ",textAlign: TextAlign.center,style:Theme.of(context).textTheme.titleMedium,),
              SizedBox(height: context.height * 0.05),
              CustomTextFormField(
                hintText:"Enter your Password",
                suffixIcon:Icon(Icons.remove_red_eye_outlined),
                obscureText:false,
                myController:controller.resetPassword,
                validator:(val) {
                  if (val == null || val.isEmpty) {
                    return "password must not be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.05),
              CustomTextFormField(
                hintText:"confirm your Password",
                suffixIcon:Icon(Icons.remove_red_eye_outlined),
                obscureText:false,
                myController:controller.confirmResetPassword,
                validator:(val) {
                  if (val == null || val.isEmpty) {
                    return "confirm password must not be empty";
                  }
                  return null;
                },

              ),
              SizedBox(height: context.height * 0.05),
              CustomButton(
                color:AppColors.primaryGreen,
                text:"done",
                onTap:(){
              //    controller.GoToVrefiy();
                },)

            ],),

          ),
        ),
      ),
    );
  }
}
