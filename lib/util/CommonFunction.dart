import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'ColorConst.dart';
import 'CommonWidget.dart';
import 'Injection.dart';
import 'StringConst.dart';

class CommonFunction {
  /// hide key board
  void hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  ///Show loader
  void showLoading() {
    EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
      indicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(DI<ColorConst>().blackColor),
        backgroundColor: DI<ColorConst>().whiteColor,
      ),
    );
  }

  void hideLoader() {
    EasyLoading.dismiss();
  }

  ///to Pick image from bottom sheet
  Future<File?> selectImage() async {
    File? imageFile;
    await showModalBottomSheet(
      backgroundColor: DI<ColorConst>().whiteColor,
      context: Get.context!,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      elevation: 5.0,
      isDismissible: false,
      builder: (context) {
        return SizedBox(
          height: 20.h,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.cancel,
                    color: DI<ColorConst>().darkGryColor,
                    size: 22,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      var file = await DI<CommonFunction>().pickImage(ImageSource.camera);
                      print(">>>>>> $file");
                      print(">camera>>>>> ${file?.path}");
                      Get.back();
                      imageFile = File(file!.path);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          color: DI<ColorConst>().colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: DI<ColorConst>().whiteColor,
                              size: 30,
                            ),
                          ),
                        ),
                        Text(
                          DI<StringConst>().camera_txt,
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().blackColor,
                              15.sp,
                              FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var file = await DI<CommonFunction>().pickImage(ImageSource.gallery);
                      print(">>>>>> $file");
                      print(">gallery>>>>> ${file?.path}");
                      Get.back();
                      imageFile = File(file!.path);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          color: DI<ColorConst>().colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.image,
                              color: DI<ColorConst>().whiteColor,
                              size: 30,
                            ),
                          ),
                        ),
                        Text(
                          DI<StringConst>().gallery_txt,
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().blackColor,
                              15.sp,
                              FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return imageFile;
  }

  ///Show toast
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message,
          maxLines : 5,style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().whiteColor,
            15.sp, FontWeight.w500),),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 5.0,
        backgroundColor: DI<ColorConst>().redColor.withOpacity(0.5),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message,style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().whiteColor,
            15.sp, FontWeight.w500),),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 5.0,
        backgroundColor: DI<ColorConst>().greenColor.withOpacity(0.5),
      ),
    );
  }


  Future<dynamic> pickImage(ImageSource imageSource) async {
    XFile? imageFile =
    await ImagePicker().pickImage(source: imageSource, imageQuality: 40);
    print("pickImage File :--  ${imageFile?.path}");

    if (imageFile != null) {


      // Crop the image
      //CroppedFile? croppedFile = await _cropImage(imageFile.path);

     // print("Cropped Image Path: ${croppedFile?.path}");

      return imageFile;

    }
    return null;
  }


 /* Future<CroppedFile?> _cropImage(filePath) async {
    CroppedFile? cropImage = await ImageCropper.platform.cropImage(
        sourcePath: filePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));

    return cropImage;
  }*/



  void addressBottomSheet(){
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(00)),
      ),
      backgroundColor: DI<ColorConst>().whiteColor,
      isDismissible: false,
      builder: (context) {
        return SizedBox(
          width: 100.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child:Icon(Icons.close,color: DI<ColorConst>().blackColor,size: 25,),

                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(DI<StringConst>().select_delivey_address_text,
                    style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 17.sp, FontWeight.w400),)
                ],
              ),
              Divider(color: DI<ColorConst>().dividerColor, thickness: 0.6),
              ListView.separated(
                itemCount: 4,
                shrinkWrap: true,
                padding:  EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:  Radio(
                      value: 1,
                      groupValue: 1,
                      activeColor: DI<ColorConst>().secondColorPrimary,
                      onChanged: (value) {
                      },
                    ),
                    title: RichText(
                      maxLines: 1,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Deliver to",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().blackColor,
                                16.sp,
                                FontWeight.w400),
                          ),
                          TextSpan(
                            text: ": ",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().blackColor,
                                16.sp,
                                FontWeight.w400),
                          ),
                          TextSpan(
                            text: "Rishabh Singh Tiwari, 452016",
                            style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().blackColor,
                              16.sp,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    ),
                    subtitle: Text(
                      "501-504 fith floor krishna tower, pipliyahna RD, indore",
                      style: TextStyle(color: DI<ColorConst>().gryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  );
                }, separatorBuilder: (context, index) {
                return SizedBox(
                  height: 0,
                );
              },),
            ],
          ),
        );
      },
    );
  }
}