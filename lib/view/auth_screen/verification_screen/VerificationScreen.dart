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

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  AuthController authController = Get.find<AuthController>();
  String email = "";
  String screenType = "";
  late TextEditingController verifyCodeCtrl;

  @override
  void initState() {
    super.initState();
    if (Get.parameters["email"] != null) {
      email = Get.parameters["email"] ?? "";
      screenType = Get.parameters["screenType"] ?? "";
    }
    verifyCodeCtrl = TextEditingController();
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
              child: Icon(Icons.mark_email_read_outlined,
                  color: DI<ColorConst>().secondColorPrimary, size: 32),
            ),
            SizedBox(height: 16),

            Text(
              DI<StringConst>().verifiy_code_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 24.sp, FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              DI<StringConst>().enter_your_verification_code_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
            ),
            SizedBox(height: 20),

            /// Success banner
            _infoBanner(
              DI<StringConst>().verification_code_sent_text,
              DI<ColorConst>().dark_greenColor,
              Icons.check_circle_outline_rounded,
            ),
            SizedBox(height: 10),

            /// Email banner
            _infoBanner(
              "${DI<StringConst>().verification_code_sent_to_text} $email",
              DI<ColorConst>().secondColorPrimary,
              Icons.mail_outline_rounded,
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
                  _fieldLabel("Verification Code"),
                  DI<CommonWidget>().myTextFormField(
                    controller: verifyCodeCtrl,
                    DI<StringConst>().enter_5_digit_verification_code_text,
                    icon: Icons.key_outlined,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            /// Hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded,
                    size: 16, color: DI<ColorConst>().darkGryColor),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    DI<StringConst>().please_check_your_mail_inbox_text,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor,
                        11.sp,
                        FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            /// Verify button
            DI<CommonWidget>()
                .myButton(DI<StringConst>().verify_email_text, () {
              if (verifyCodeCtrl.text.trim().isEmpty) {
                DI<CommonFunction>().showErrorSnackBar(
                    DI<StringConst>().please_enter_verification_code_text);
              } else {
                authController.userVerifyCode(
                    email, verifyCodeCtrl.text.trim(), screenType);
              }
            }),
            SizedBox(height: 20),

            Text(
              DI<StringConst>().did_not_receive_code_text,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400),
            ),
            SizedBox(height: 10),

            /// Resend button
            InkWell(
              onTap: () {
                authController.resendVerificationCode(email);
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
                  DI<StringConst>().resend_verification_code_text,
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

  Widget _infoBanner(String text, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              style: DI<CommonWidget>()
                  .myTextStyle(color, 12.sp, FontWeight.w500),
            ),
          ),
        ],
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
}
