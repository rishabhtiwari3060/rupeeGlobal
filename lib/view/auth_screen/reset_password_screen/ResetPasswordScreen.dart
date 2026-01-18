import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
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
        leading: InkWell(onTap: (){
          Get.back();
        },
            child: Icon(Icons.arrow_back_ios,color: DI<ColorConst>().blackColor,)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Image.asset(DI<ImageConst>().APP_ICON,width: 70.w,height: 15.w,alignment: Alignment.center,)),
            SizedBox(
              height: 20,
            ),

            Text(DI<StringConst>().reset_password_text,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 25.sp, FontWeight.w500),),

            Text(DI<StringConst>().enter_your_new_password_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 18.sp, FontWeight.w400),),

            SizedBox(
              height: 20,
            ),


            Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              decoration:BoxDecoration(
                  color: DI<ColorConst>().greenColor.withOpacity(0.3),

                  border: Border.all(color: DI<ColorConst>().greenColor,
                      width: 2),
                  borderRadius: BorderRadius.circular(7)
              ),
              child:   Text(DI<StringConst>().verification_successful_text,
                style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().dark_greenColor, 15.sp, FontWeight.w400),),
            ),

            SizedBox(
              height: 10,
            ),




            DI<CommonWidget>().myTextFormField(DI<StringConst>().enter_new_password_text,
                icon: Icons.lock,
                textInputAction: TextInputAction.next),
            SizedBox(
              height: 10,
            ),
            DI<CommonWidget>().myTextFormField(DI<StringConst>().enter_confirm_new_password_text,
                icon: Icons.lock,
                textInputAction: TextInputAction.done),
            SizedBox(
              height: 20,
            ),


            DI<CommonWidget>().myButton(DI<StringConst>().reset_password_text,(){

              Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
            }),
            SizedBox(
              height: 20,
            ),


            InkWell(
              onTap: (){
                Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
              },
              child: Container(
                width: 100.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                decoration:BoxDecoration(


                    border: Border.all(color: DI<ColorConst>().redColor,
                        width: 2),
                    borderRadius: BorderRadius.circular(7)
                ),
                child:   Text(DI<StringConst>().back_to_login_text,
                  style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().redColor, 15.sp, FontWeight.w400),),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
