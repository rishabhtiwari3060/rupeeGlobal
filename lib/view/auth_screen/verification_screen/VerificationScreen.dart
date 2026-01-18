import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
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

  String email = "";
  String screenType = "";
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    if(Get.parameters["email"] != null){
      email = Get.parameters["email"]??"";
      screenType = Get.parameters["screenType"]??"";
    }

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

            Text(DI<StringConst>().verifiy_code_text,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 25.sp, FontWeight.w500),),

            Text(DI<StringConst>().enter_your_verification_code_text,
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
              child:   Text(DI<StringConst>().verification_code_sent_text,
                style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().dark_greenColor, 15.sp, FontWeight.w400),),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              decoration:BoxDecoration(
                  color: DI<ColorConst>().secondColorPrimary.withOpacity(0.3),

                  border: Border.all(color: DI<ColorConst>().secondColorPrimary,
                      width: 2),
                  borderRadius: BorderRadius.circular(7)
              ),
              child:  Row(
                children: [
                  Expanded(
                      flex:0,
                      child: Icon(Icons.mail, color:DI<ColorConst>().secondColorPrimary ,)),
                  SizedBox(width: 5,),
                  Expanded(
                    flex:0,
                    child: Text(DI<StringConst>().verification_code_sent_to_text,
                      style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().secondColorPrimary, 15.sp, FontWeight.w400),),
                  ),

                  Expanded(
                    flex:1,
                    child: Text(" $email",
                      maxLines: 2,
                      style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().secondColorPrimary, 15.sp, FontWeight.w500),),
                  ),
                ],
              )
            ),
            SizedBox(
              height: 20,
            ),


            DI<CommonWidget>().myTextFormField("Enter 5-digit verification code",
                icon: Icons.key,
                textInputAction: TextInputAction.done),

            SizedBox(
              height: 20,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex:0,
                    child: Icon(Icons.watch_later, color:DI<ColorConst>().darkGryColor ,)),
                SizedBox(width: 5,),
                Expanded(
                  flex:1,
                  child: Text(DI<StringConst>().please_check_your_mail_inbox_text,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 15.sp, FontWeight.w400),),

                ),


              ],
            ),
            SizedBox(
              height: 30,
            ),
            DI<CommonWidget>().myButton("Verify Email",(){

              if(screenType == "FORGOTPASSWORD"){
                Get.toNamed(DI<RouteHelper>().getResetPasswordScreen());
              }else{
                Get.toNamed(DI<RouteHelper>().getHomeTabScreen());
              }


            }),
            SizedBox(
              height: 20,
            ),

            Text(DI<StringConst>().did_not_receive_code_text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 15.sp, FontWeight.w400),),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){

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
                child:   Text(DI<StringConst>().resend_verification_code_text,
                  style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().redColor, 15.sp, FontWeight.w400),),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
