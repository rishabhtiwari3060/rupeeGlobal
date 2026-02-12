import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/ImageConst.dart';
import '../../../util/Injection.dart';
import '../../../util/RouteHelper.dart';
import '../../../util/StringConst.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = Get.find<AuthController>();

  var checkBoxValue = false.obs;
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController panNumCtrl;
  late TextEditingController passwordCtrl;
  late TextEditingController confirmPassCtrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    panNumCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    confirmPassCtrl = TextEditingController();
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
            /// Logo
            Image.asset(
              DI<ImageConst>().APP_ICON,
              width: 60.w,
              height: 14.w,
            ),
            SizedBox(height: 20),

            Text(
              DI<StringConst>().welcome_again_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 24.sp, FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              DI<StringConst>().enter_Register_details_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
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
                  _fieldLabel("Full Name"),
                  DI<CommonWidget>().myTextFormField(
                    controller: nameCtrl,
                    DI<StringConst>().full_name_text,
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),
                  _fieldLabel("Email Address"),
                  DI<CommonWidget>().myTextFormField(
                    controller: emailCtrl,
                    DI<StringConst>().email_address_text,
                    icon: Icons.email_outlined,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),
                  _fieldLabel("Mobile Number"),
                  DI<CommonWidget>().myTextFormField(
                    controller: phoneCtrl,
                    DI<StringConst>().mobile_number_text,
                    icon: Icons.phone_android_outlined,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),
                  _fieldLabel("PAN Number"),
                  DI<CommonWidget>().myTextFormField(
                    controller: panNumCtrl,
                    DI<StringConst>().pan_number_text,
                    icon: Icons.credit_card_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),
                  _fieldLabel("Password"),
                  DI<CommonWidget>().myTextFormField(
                    controller: passwordCtrl,
                    DI<StringConst>().password_text,
                    icon: Icons.lock_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),
                  _fieldLabel("Confirm Password"),
                  DI<CommonWidget>().myTextFormField(
                    controller: confirmPassCtrl,
                    DI<StringConst>().confirm_password_text,
                    icon: Icons.lock_outline_rounded,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            _termsCheckbox(),
            SizedBox(height: 20),

            DI<CommonWidget>()
                .myButton(DI<StringConst>().createAccountText, () {
              if (_validation()) {
                authController.userRegister(
                  nameCtrl.text.trim(),
                  emailCtrl.text.trim(),
                  phoneCtrl.text.trim(),
                  panNumCtrl.text.trim(),
                  passwordCtrl.text.trim(),
                  confirmPassCtrl.text.trim(),
                );
              }
            }),
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

  Widget _termsCheckbox() {
    return Obx(() => CheckboxListTile(
          title: Text(
            DI<StringConst>().by_continue_you_agree_text,
            maxLines: 2,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: DI<ColorConst>().secondColorPrimary,
          contentPadding: EdgeInsets.zero,
          value: checkBoxValue.value,
          onChanged: (value) {
            checkBoxValue.value = value!;
          },
        ));
  }

  bool _validation() {
    if (nameCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_full_name_text);
      return false;
    } else if (emailCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_email_text);
      return false;
    } else if (!emailCtrl.text.trim().isEmail) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_valid_email_text);
      return false;
    } else if (phoneCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_phone_Text);
      return false;
    } else if (panNumCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_pan_num_text);
      return false;
    } else if (passwordCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_password_text);
      return false;
    } else if (passwordCtrl.text.trim().length < 8) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().password_grater_8_digit_text);
      return false;
    } else if (confirmPassCtrl.text.trim().isEmpty) {
      DI<CommonFunction>().showErrorSnackBar(
          DI<StringConst>().please_enter_confirm_password_text);
      return false;
    } else if (confirmPassCtrl.text.trim() != passwordCtrl.text.trim()) {
      DI<CommonFunction>().showErrorSnackBar(
          DI<StringConst>().please_enter_same_password_text);
      return false;
    } else if (!checkBoxValue.value) {
      DI<CommonFunction>().showErrorSnackBar(
          DI<StringConst>().please_accept_trems_condition_text);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    panNumCtrl.dispose();
    passwordCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }
}
