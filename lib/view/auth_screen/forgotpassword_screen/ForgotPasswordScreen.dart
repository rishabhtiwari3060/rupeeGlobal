import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/ImageConst.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  AuthController authController = Get.find<AuthController>();

  late TextEditingController emailCtrl;

  @override
  void initState() {
   WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    emailCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(onTap: (){
          Get.back();
        },
            child: Icon(Icons.arrow_back_ios,color: DI<ColorConst>().blackColor,)),
      ),
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

            Text(DI<StringConst>().forgot_password_text,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 25.sp, FontWeight.w500),),

            Text(DI<StringConst>().enter_your_email_for_varification_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 18.sp, FontWeight.w400),),

            SizedBox(
              height: 15.w,
            ),

            DI<CommonWidget>().myTextFormField(
                controller:emailCtrl,
                DI<StringConst>().email_address_text,
                icon: Icons.email,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done),

            SizedBox(
              height: 15.w,
            ),
            DI<CommonWidget>().myButton(DI<StringConst>().send_verifiation_code_text,(){

              if(validation()){
                authController.sendForgotPasswordCode(emailCtrl.text.trim());
              }

            }),

            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: DI<StringConst>().remember_your_password_text,
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
                        text: DI<StringConst>().sign_in_text,
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


  bool validation(){
    if(emailCtrl.text.trim().isEmpty){

      DI<CommonFunction>().showErrorSnackBar(DI<StringConst>().please_enter_email_text);

      return false;
    }else if (!emailCtrl.text.trim().isEmail){
      DI<CommonFunction>().showErrorSnackBar(DI<StringConst>().please_enter_valid_email_text);

      return false;
    }

    return true;
  }
}
