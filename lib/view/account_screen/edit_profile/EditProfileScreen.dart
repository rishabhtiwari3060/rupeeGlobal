import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AccountController accountController = Get.find<AccountController>();

  var imageFile = Rxn<File>();
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController mobileCtrl;
  late TextEditingController panNumberCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: accountController.userName.value);
    emailCtrl = TextEditingController(text: accountController.email);
    mobileCtrl = TextEditingController(text: accountController.phone);
    panNumberCtrl = TextEditingController(text: accountController.panNo);
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
        title: Text(
          DI<StringConst>().edit_profile_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 18.sp, FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            /// Avatar section
            Center(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: DI<ColorConst>().secondColorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    accountController.userName.value.isNotEmpty
                        ? accountController.userName.value[0].toUpperCase()
                        : "U",
                    style: TextStyle(
                      color: DI<ColorConst>().secondColorPrimary,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                DI<StringConst>().enter_your_profile_detail_text,
                textAlign: TextAlign.center,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400),
              ),
            ),
            SizedBox(height: 24),

            /// Form Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DI<ColorConst>().cardBgColor,
                borderRadius: BorderRadius.circular(14),
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
                    DI<StringConst>().enter_full_name_Text,
                    icon: Icons.person_outline_rounded,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),

                  _fieldLabel("Email Address"),
                  DI<CommonWidget>().myTextFormField(
                    controller: emailCtrl,
                    DI<StringConst>().email_address_text,
                    icon: Icons.email_outlined,
                    enable: false,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 14),

                  _fieldLabel("Mobile Number"),
                  DI<CommonWidget>().myTextFormField(
                    controller: mobileCtrl,
                    DI<StringConst>().enter_mobile_Text,
                    icon: Icons.phone_android_outlined,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 14),

                  _fieldLabel("PAN Number"),
                  DI<CommonWidget>().myTextFormField(
                    controller: panNumberCtrl,
                    DI<StringConst>().pan_number_text,
                    icon: Icons.credit_card_outlined,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            DI<CommonWidget>().myButton(DI<StringConst>().save_text, () {
              if (_validation()) {
                accountController.updateProfile(
                  nameCtrl.text.trim(),
                  mobileCtrl.text.trim(),
                  panNumberCtrl.text.trim(),
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

  bool _validation() {
    if (nameCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_full_name_text);
      return false;
    } else if (mobileCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_mobile_number_Text);
      return false;
    } else if (panNumberCtrl.text.trim().isEmpty) {
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_pan_num_text);
      return false;
    }
    return true;
  }
}
