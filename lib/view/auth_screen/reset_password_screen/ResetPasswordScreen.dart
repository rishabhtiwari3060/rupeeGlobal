import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/ImageConst.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  AuthController authController = Get.find<AuthController>();

  late TextEditingController newPasswordCtrl;
  late TextEditingController confirmPasswordCtrl;
  String email = "";

  @override
  void initState() {
    super.initState();
    if (Get.parameters["email"] != null) {
      email = Get.parameters["email"] ?? "";
    }
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();
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
          children: [
            SizedBox(height: 10),

            /// Logo
            Image.asset(
              DI<ImageConst>().APP_ICON,
              width: 60.w,
              height: 14.w,
            ),
            SizedBox(height: 24),

            /// Icon
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: DI<ColorConst>().secondColorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.lock_outline_rounded,
                  color: DI<ColorConst>().secondColorPrimary, size: 32),
            ),
            SizedBox(height: 16),

            Text(
              DI<StringConst>().reset_password_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 24.sp, FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              DI<StringConst>().enter_your_new_password_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
            ),
            SizedBox(height: 20),

            /// Success banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: DI<ColorConst>().dark_greenColor.withOpacity(0.08),
                border: Border.all(
                    color:
                        DI<ColorConst>().dark_greenColor.withOpacity(0.3),
                    width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: DI<ColorConst>().dark_greenColor, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      DI<StringConst>().verification_successful_text,
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().dark_greenColor,
                          12.sp,
                          FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

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
                  _fieldLabel("New Password"),
                  DI<CommonWidget>().myTextFormField(
                    controller: newPasswordCtrl,
                    DI<StringConst>().enter_new_password_text,
                    icon: Icons.lock_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),
                  _fieldLabel("Confirm Password"),
                  DI<CommonWidget>().myTextFormField(
                    controller: confirmPasswordCtrl,
                    DI<StringConst>().enter_confirm_new_password_text,
                    icon: Icons.lock_outline_rounded,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            /// Reset button
            DI<CommonWidget>()
                .myButton(DI<StringConst>().reset_password_text, () {
              if (_validation()) {
                authController.resetPasswordCode(
                  email,
                  newPasswordCtrl.text.trim(),
                  confirmPasswordCtrl.text.trim(),
                );
              }
            }),
            SizedBox(height: 16),

            /// Back to login
            InkWell(
              onTap: () {
                Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DI<ColorConst>().secondColorPrimary.withOpacity(0.5),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  DI<StringConst>().back_to_login_text,
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      13.sp,
                      FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 20),
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
    if (newPasswordCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_new_password_text);
      return false;
    } else if (newPasswordCtrl.text.trim().length < 8) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().password_grater_8_digit_text);
      return false;
    } else if (confirmPasswordCtrl.text.trim().isEmpty) {
      DI<CommonFunction>().showErrorSnackBar(
          DI<StringConst>().please_enter_confirm_password_text);
      return false;
    } else if (confirmPasswordCtrl.text.trim() !=
        newPasswordCtrl.text.trim()) {
      DI<CommonFunction>().showErrorSnackBar(
          DI<StringConst>().please_enter_same_password_text);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }
}
