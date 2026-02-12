import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/util/ColorConst.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/CommonWidget.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:rupeeglobal/util/local_storage.dart';
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
    super.initState();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();

    /// Load saved credentials if remember me was checked
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final storage = DI<MyLocalStorage>();
    final isRemembered = storage.getBoolValue(storage.rememberMe);
    if (isRemembered) {
      emailCtrl.text = storage.getStringValue(storage.rememberEmail);
      passwordCtrl.text = storage.getStringValue(storage.rememberPassword);
      authController.checkBoxValue.value = true;
    }
  }

  void _saveOrClearCredentials() {
    final storage = DI<MyLocalStorage>();
    if (authController.checkBoxValue.value) {
      storage.setBoolValue(storage.rememberMe, true);
      storage.setStringValue(storage.rememberEmail, emailCtrl.text.trim());
      storage.setStringValue(storage.rememberPassword, passwordCtrl.text.trim());
    } else {
      storage.setBoolValue(storage.rememberMe, false);
      storage.setStringValue(storage.rememberEmail, "");
      storage.setStringValue(storage.rememberPassword, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              /// Logo
              Image.asset(
                DI<ImageConst>().APP_ICON,
                width: 60.w,
                height: 14.w,
              ),
              SizedBox(height: 30),

              /// Welcome text
              Text(
                DI<StringConst>().welcome_again_text,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor, 26.sp, FontWeight.w700),
              ),
              SizedBox(height: 4),
              Text(
                DI<StringConst>().enter_login_details_text,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().darkGryColor, 15.sp, FontWeight.w400),
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
                    _fieldLabel("Email / Mobile"),
                    DI<CommonWidget>().myTextFormField(
                      controller: emailCtrl,
                      DI<StringConst>().enter_email_mobile_text,
                      icon: Icons.person_outline_rounded,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16),
                    _fieldLabel("Password"),
                    DI<CommonWidget>().myTextFormField(
                      controller: passwordCtrl,
                      DI<StringConst>().enter_password_Text,
                      icon: Icons.lock_outline_rounded,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              /// Remember me + Forgot
              Row(
                children: [
                  Expanded(child: _rememberMeCheckbox()),
                  InkWell(
                    onTap: () {
                      Get.toNamed(DI<RouteHelper>().getForgotPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().secondColorPrimary,
                          15.sp,
                          FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              /// Login Button
              DI<CommonWidget>().myButton(DI<StringConst>().login_text, () {
                if (_validation()) {
                  _saveOrClearCredentials();
                  authController.userLogin(
                      emailCtrl.text.trim(), passwordCtrl.text.trim());
                }
              }),
              SizedBox(height: 20),

              /// Sign up link
              InkWell(
                onTap: () {
                  Get.toNamed(DI<RouteHelper>().getSignupScreen());
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: DI<StringConst>().donot_have_account_text,
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor,
                            15.sp,
                            FontWeight.w400),
                      ),
                      TextSpan(
                        text: " ${DI<StringConst>().sign_up_text}",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().secondColorPrimary,
                            15.sp,
                            FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
            DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w400),
      ),
    );
  }

  Widget _rememberMeCheckbox() {
    return Obx(() => CheckboxListTile(
          title: Text(
            DI<StringConst>().remember_me_text,
            maxLines: 1,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 15.sp, FontWeight.w400),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: DI<ColorConst>().secondColorPrimary,
          contentPadding: EdgeInsets.zero,
          value: authController.checkBoxValue.value,
          onChanged: (value) {
            authController.checkBoxValue.value = value!;
          },
        ));
  }

  bool _validation() {
    if (emailCtrl.text.trim().isEmpty) {
      DI<CommonFunction>().showErrorSnackBar(
          "Please ${DI<StringConst>().enter_email_mobile_text}");
      return false;
    } else if (passwordCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_password_text);
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
