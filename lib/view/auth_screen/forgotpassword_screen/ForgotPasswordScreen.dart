import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
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
    super.initState();
    emailCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: DI<ColorConst>().blackColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            /// Logo
            Image.asset(
              DI<ImageConst>().APP_ICON,
              width: 60.w,
              height: 14.w,
            ),
            SizedBox(height: 30),

            /// Icon
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: DI<ColorConst>().secondColorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.lock_reset_rounded,
                  color: DI<ColorConst>().secondColorPrimary, size: 32),
            ),
            SizedBox(height: 16),

            Text(
              DI<StringConst>().forgot_password_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 24.sp, FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              DI<StringConst>().enter_your_email_for_varification_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
            ),
            SizedBox(height: 30),

            /// Form Card
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: DI<ColorConst>().cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: DI<ColorConst>().dividerColor.withOpacity(0.4),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Email Address"),
                  DI<CommonWidget>().myTextFormField(
                    controller: emailCtrl,
                    DI<StringConst>().email_address_text,
                    icon: Icons.email_outlined,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            DI<CommonWidget>()
                .myButton(DI<StringConst>().send_verifiation_code_text, () {
              if (_validation()) {
                authController.sendForgotPasswordCode(emailCtrl.text.trim());
              }
            }),
            SizedBox(height: 20),

            /// Back to login
            InkWell(
              onTap: () => Get.back(),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: DI<StringConst>().remember_your_password_text,
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().darkGryColor,
                          13.sp,
                          FontWeight.w400),
                    ),
                    TextSpan(
                      text: " ${DI<StringConst>().sign_in_text}",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().secondColorPrimary,
                          13.sp,
                          FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: DI<CommonWidget>().myTextStyle(
            DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400),
      ),
    );
  }

  bool _validation() {
    if (emailCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_email_text);
      return false;
    } else if (!emailCtrl.text.trim().isEmail) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_valid_email_text);
      return false;
    }
    return true;
  }
}
