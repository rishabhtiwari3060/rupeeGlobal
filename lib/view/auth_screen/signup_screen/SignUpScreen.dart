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
    WidgetsFlutterBinding.ensureInitialized();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: DI<ColorConst>().blackColor,
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.center,
                child: Image.asset(
                  DI<ImageConst>().APP_ICON,
                  width: 70.w,
                  height: 15.w,
                  alignment: Alignment.center,
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              DI<StringConst>().welcome_again_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 25.sp, FontWeight.w500),
            ),
            Text(
              DI<StringConst>().enter_Register_details_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 18.sp, FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            DI<CommonWidget>().myTextFormField(
                controller: nameCtrl,
                DI<StringConst>().full_name_text,
                icon: Icons.person, textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),
            DI<CommonWidget>().myTextFormField(
                controller: emailCtrl,
                DI<StringConst>().email_address_text,
                icon: Icons.email,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),
            DI<CommonWidget>().myTextFormField(
                controller: phoneCtrl,
                DI<StringConst>().mobile_number_text,
                icon: Icons.phone_android,
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),
            DI<CommonWidget>().myTextFormField(
                controller: panNumCtrl,
                DI<StringConst>().pan_number_text,
                icon: Icons.credit_card,

                textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),
            DI<CommonWidget>().myTextFormField(
                controller: passwordCtrl,
                DI<StringConst>().password_text,
                icon: Icons.password, textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),
            DI<CommonWidget>().myTextFormField(
                controller: confirmPassCtrl,
                DI<StringConst>().confirm_password_text,
                icon: Icons.password,
                textInputAction: TextInputAction.done),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            termsNConditionCheckBox(),
            SizedBox(
              height: 30,
            ),
            DI<CommonWidget>().myButton(DI<StringConst>().createAccountText,
                () {

              if(validation()){

                authController.userRegister(nameCtrl.text.trim(),
                    emailCtrl.text.trim(),
                    phoneCtrl.text.trim(),
                    panNumCtrl.text.trim(),
                    passwordCtrl.text.trim(),
                    confirmPassCtrl.text.trim());

              }

            }),
          ],
        ),
      ),
    );
  }

  Widget termsNConditionCheckBox() {
    return Obx(() => CheckboxListTile(
          title: Text(
            DI<StringConst>().by_continue_you_agree_text,
            maxLines: 2,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 15.sp, FontWeight.w400),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: DI<ColorConst>().redColor,
          contentPadding: EdgeInsets.zero,
          value: checkBoxValue.value,
          onChanged: (value) {
            checkBoxValue.value = value!;
          },
        ));
  }

  bool validation() {
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
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_confirm_password_text);

      return false;
    } else if (confirmPassCtrl.text.trim() != passwordCtrl.text.trim()) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_same_password_text);

      return false;
    }else if (!checkBoxValue.value) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_accept_trems_condition_text);

      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    panNumCtrl.dispose();
    passwordCtrl.dispose();
    confirmPassCtrl.dispose();
  }
}
