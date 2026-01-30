import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/ImageConst.dart';
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
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    nameCtrl = TextEditingController(text: accountController.userName.value);
    emailCtrl = TextEditingController(text: accountController.email);
    mobileCtrl = TextEditingController(text: accountController.phone);
    panNumberCtrl = TextEditingController(text: accountController.panNo);
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
        title: Text(
         "",
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

            SizedBox(
              height: 7.w,
            ),
            Align(
                alignment: Alignment.center,
                child: Image.asset(DI<ImageConst>().APP_ICON,width: 70.w,height: 15.w,alignment: Alignment.center,)),
            SizedBox(
              height: 20,
            ),

            Text(DI<StringConst>().edit_profile_text,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 25.sp, FontWeight.w500),),

            Text(DI<StringConst>().enter_your_profile_detail_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 18.sp, FontWeight.w400),),

            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 10.w,
            ),
            DI<CommonWidget>().myTextFormField(
              controller: nameCtrl,
                DI<StringConst>().enter_full_name_Text,
                icon: Icons.person,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),

            DI<CommonWidget>().myTextFormField(
                controller: emailCtrl,
                DI<StringConst>().email_address_text,
                icon: Icons.email,
                enable: false,
                textInputAction: TextInputAction.done),

            SizedBox(
              height: 10,
            ),

            DI<CommonWidget>().myTextFormField(
                controller: mobileCtrl,
                DI<StringConst>().enter_mobile_Text,
                icon: Icons.phone_android,
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.next),



            SizedBox(
              height: 10,
            ),

            DI<CommonWidget>().myTextFormField(
                controller: panNumberCtrl,
                DI<StringConst>().pan_number_text,
                icon: Icons.credit_card,
                textInputAction: TextInputAction.done),
            SizedBox(
              height: 30.w,
            ),
           /* DI<CommonWidget>().myButton(DI<StringConst>().save_text,(){
              if(validation()){
                accountController.updateProfile(nameCtrl.text.trim(),
                    mobileCtrl.text.trim(), panNumberCtrl.text.trim());
              }
            }),*/
          ],
        ),
      ),
    );
  }

  Widget profileViewCard() {
    return Center(
      child: Obx(
            () {
          return Stack(children: [
            Card(
              color: Colors.white,
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.sp),
                  side: BorderSide(color: DI<ColorConst>().gryColor, width: 1)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45.sp),
                child: imageFile.value != null
                    ? Image.file(imageFile.value!, height: 45.sp, width: 45.sp)
                    : FadeInImage.assetNetwork(
                  placeholder: DI<ImageConst>().IMAGE_LOADING,
                  image: "",
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      DI<ImageConst>().PERSON_DEFAULT_IMAGE,
                      height: 45.sp,
                      width: 45.sp,
                    );
                  },
                  fit: BoxFit.cover,
                  height: 45.sp,
                  width: 45.sp,
                ),
              ),
            ),
            Positioned(
              bottom: 9.0,
              right: 10.0,
              child: InkWell(
                onTap: () async {
                  print("Pick image");
                  await DI<CommonFunction>().selectImage().then(
                        (value) {
                      imageFile.value = value;
                    },
                  );
                },
                child: Image.asset(
                  DI<ImageConst>().blackCameraIcon,
                  height: 21.sp,
                ),
              ),
            )
          ]);
        },
      ),
    );
  }



  bool validation(){
    if(nameCtrl.text.trim().isEmpty){
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_full_name_text);
      return false;
    } else if(mobileCtrl.text.trim().isEmpty){
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_mobile_number_Text);
      return false;
    }else if(panNumberCtrl.text.trim().isEmpty){
      DI<CommonFunction>()
          .showErrorSnackBar(DI<StringConst>().please_enter_pan_num_text);
      return false;
    }


    return true;
  }

}
