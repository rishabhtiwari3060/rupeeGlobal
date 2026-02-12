import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';


import 'ColorConst.dart';
import 'ImageConst.dart';
import 'Injection.dart';
import 'StringConst.dart';

class CommonWidget {
  TextStyle myTextStyle(Color txtColor, double size, FontWeight fw) {
    return TextStyle(
        color: txtColor,
        fontSize: size,
        fontWeight: fw,
        fontFamily: "Roboto",
        overflow: TextOverflow.ellipsis);
  }

  TextFormField myTextFormField(String hintText,
      {TextEditingController? controller,
      TextInputAction? textInputAction,
      TextInputType? textInputType,
      IconData? icon,
      int? maxLine,
      int? minLine,
      bool? enable}) {
    return TextFormField(
      controller: controller,
      enabled: enable,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textInputAction: textInputAction,
      keyboardType: textInputType,
      minLines: minLine,
      maxLines: maxLine,
      style: DI<CommonWidget>()
          .myTextStyle(DI<ColorConst>().blackColor, 15.sp, FontWeight.w500),
      decoration: InputDecoration(
          fillColor: DI<ColorConst>().gryColor,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.7),
              borderSide:
              BorderSide(color: DI<ColorConst>().gryColor, width: 1.0)),
          hintText: hintText,
          hintStyle: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().darkGryColor, 14.sp, FontWeight.normal),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0),
              borderSide:
              BorderSide(color: DI<ColorConst>().gryColor, width: 1.0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0),
              borderSide:
              BorderSide(color: DI<ColorConst>().gryColor, width: 1.0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0),
              borderSide:
              BorderSide(color: DI<ColorConst>().gryColor, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0),
              borderSide:
              BorderSide(color: DI<ColorConst>().gryColor, width: 1.0)),
          contentPadding: EdgeInsets.only(top: 10, left: 10, bottom: 0),
          prefixIcon:icon==null?null: Icon(icon, color: DI<ColorConst>().darkGryColor, size: 25)),
    );
  }

  Widget myButton(String buttonText, void Function() onClick) {
    return SizedBox(
      width: 100.sp,
      height: 28.sp,
      child: ElevatedButton(
        onPressed: onClick,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0.0),
            backgroundColor:
                WidgetStatePropertyAll(DI<ColorConst>().redColor)),
        child: Text(
          buttonText,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().whiteColor, 16.sp, FontWeight.w400),
        ),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: DI<ColorConst>().blackColor,
        ),
      ),
      automaticallyImplyLeading: false,
      elevation: 0.0,
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      actions: [
        InkWell(
            onTap: () {

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            )),
        InkWell(
            onTap: () {

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart_outlined),
            ))
      ],
    );
  }

  AppBar myAppBarWithTitle(String title) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: DI<ColorConst>().blackColor,
        ),
      ),
      title: Text(
        title,
        style: DI<CommonWidget>()
            .myTextStyle(DI<ColorConst>().blackColor, 17.sp, FontWeight.w400),
      ),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
    );
  }

  ///To Show Alert Dialog
  Future errorDialog(String errorMsg, Function() onClick) {
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 3,
              insetPadding: EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              child: Container(
                width: 100.w,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DI<StringConst>().alert_txt,
                          style: TextStyle(
                              color: DI<ColorConst>().blackColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: DI<ColorConst>().darkGryColor,
                          ),
                        )
                      ],
                    ),
                    Divider(color: DI<ColorConst>().dividerColor, thickness: 0.6),
                    SizedBox(
                      height: 17.sp,
                    ),
                    /*Image.asset(
                      DI<ImageConst>().ALERT_ICON,
                      height: 35.sp,
                    ),*/
                    SizedBox(
                      height: 17.sp,
                    ),
                    Text(
                      errorMsg,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().blackColor, 15.sp, FontWeight.w500),
                    ),
                    SizedBox(
                      height: 17.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 46.sp),
                      child: DI<CommonWidget>()
                          .myButton(DI<StringConst>().okText, onClick),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

}
