import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/util/ColorConst.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/CommonWidget.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ImageConst.dart';
import '../../../util/Injection.dart';
import '../../../util/RouteHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 AuthController authController = Get.find<AuthController>();

 late TextEditingController emailCtrl;
 late TextEditingController passwordCtrl;
  @override
  void initState() {
   WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Align(
                alignment: Alignment.center,
                child: Image.asset(DI<ImageConst>().APP_ICON,width: 70.w,height: 15.w,alignment: Alignment.center,)),
            SizedBox(
              height: 20,
            ),

            Text(DI<StringConst>().welcome_again_text,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 25.sp, FontWeight.w500),),

            Text(DI<StringConst>().enter_login_details_text,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 18.sp, FontWeight.w400),),

            SizedBox(
              height: 15.w,
            ),


            DI<CommonWidget>().myTextFormField(
                controller: emailCtrl,
                DI<StringConst>().enter_email_mobile_text,
            icon: Icons.person,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next),

            SizedBox(
              height: 10,
            ),

            DI<CommonWidget>().myTextFormField(
                controller: passwordCtrl,
                DI<StringConst>().enter_password_Text,
                icon: Icons.password,
                textInputAction: TextInputAction.done),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: termsNConditionCheckBox()),

                Expanded(
                  flex: 0,
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(DI<RouteHelper>().getForgotPasswordScreen());
                    },
                    child: Text("Forgot Password?",style:  DI<CommonWidget>()
                        .myTextStyle(DI<ColorConst>().redColor, 15.sp, FontWeight.w500),),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12.w,
            ),
            DI<CommonWidget>().myButton(DI<StringConst>().login_text,(){

              if(validation()){
                authController.userLogin(emailCtrl.text.trim(), passwordCtrl.text.trim());
              }
            }),

            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Get.toNamed(DI<RouteHelper>().getSignupScreen());
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: DI<StringConst>().donot_have_account_text,
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().blackColor,
                            16.sp,
                            FontWeight.w400),
                      ),
                      TextSpan(
                        text: " ",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor,
                            16.sp,
                            FontWeight.w400),
                      ),
                      TextSpan(
                        text: DI<StringConst>().sign_up_text,
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().redColor,
                            16.sp,
                            FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget termsNConditionCheckBox() {
    return Obx(() => CheckboxListTile(
      title: Text(
        DI<StringConst>().remember_me_text,
        maxLines: 2,
        style: DI<CommonWidget>().myTextStyle(
            DI<ColorConst>().blackColor, 15.sp, FontWeight.w400),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: DI<ColorConst>().redColor,
      contentPadding: EdgeInsets.zero,
      value: authController.checkBoxValue.value,
      onChanged: (value) {
        authController.checkBoxValue.value = value!;
      },
    ));
  }


  bool validation(){
    if(emailCtrl.text.trim().isEmpty){
      DI<CommonFunction>().showErrorSnackBar("please ${DI<StringConst>().enter_email_mobile_text}");

      return false;
    }  else if(passwordCtrl.text.trim().isEmpty){
      DI<CommonFunction>().showErrorSnackBar(DI<StringConst>().please_enter_password_text);

      return false;
    }
    return true;
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
