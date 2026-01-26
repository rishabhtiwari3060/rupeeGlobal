import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var imageFile = Rxn<File>();


  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
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
         DI<StringConst>().edit_profile_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),

      body: Column(
        children: [
          profileViewCard(),


          DI<CommonWidget>().myTextFormField(
              DI<StringConst>().enter_full_name_Text,
              icon: Icons.person,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next),

          SizedBox(
            height: 10,
          ),

          DI<CommonWidget>().myTextFormField(
              DI<StringConst>().enter_mobile_Text,
              icon: Icons.phone_android,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.next),



          SizedBox(
            height: 10,
          ),

          DI<CommonWidget>().myTextFormField(
              DI<StringConst>().pan_number_text,
              icon: Icons.credit_card,
              textInputAction: TextInputAction.done),
          SizedBox(
            height: 12.w,
          ),
          DI<CommonWidget>().myButton(DI<StringConst>().save_text,(){

          }),
        ],
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
}
