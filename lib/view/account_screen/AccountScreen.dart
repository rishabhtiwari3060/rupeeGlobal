import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/util/ColorConst.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../util/CommonWidget.dart';
import '../../util/ImageConst.dart';
import '../../util/Injection.dart';
import '../../util/RandomColor.dart';
import '../../util/StringConst.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  late List<Color> cardColors;
  String firstLetter = "";

  @override
  void initState() {
   WidgetsFlutterBinding.ensureInitialized();
    super.initState();
   cardColors = List.generate(12, (_) => getLightBrightColor());

   if(DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().userName).isNotEmpty){
    firstLetter = DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().userName)[0];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().whiteColor,
      appBar: AppBar(
        backgroundColor:  DI<ColorConst>().whiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color:  DI<ColorConst>().redColor.withOpacity(0.3),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                      child:  Card(
                        color: Colors.white,
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.sp),
                            side: BorderSide(color: DI<ColorConst>().gryColor, width: 1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45.sp),
                          child: FadeInImage.assetNetwork(
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
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().userName,),style:  DI<CommonWidget>()
                        .myTextStyle(DI<ColorConst>().blackColor, 16.sp, FontWeight.w400),),

                  ],
                ),
              ),
            ),
           SizedBox(
              height: 7.w,
            ),

            customView(Icons.person,cardColors[6], DI<StringConst>().edit_profile_text, (){
              Get.toNamed(
                  DI<RouteHelper>().getEditProfileScreen());

            }),
            SizedBox(
              height: 10,
            ),

            customView(Icons.support_agent,cardColors[0], DI<StringConst>().support_ticket_text, (){

              Get.toNamed(DI<RouteHelper>().getSupportTicketScreen());

            }),
            SizedBox(
              height: 10,
            ),
            customView(Icons.calculate_outlined, cardColors[1],DI<StringConst>().pms_text, (){
              Get.toNamed(DI<RouteHelper>().getPmsScreen());

            }),

            SizedBox(
              height: 10,
            ),
            customView(Icons.newspaper,cardColors[3], DI<StringConst>().news_text, (){

              Get.toNamed(DI<RouteHelper>().getNewsScreen());
            }),

            SizedBox(
              height: 10,
            ),
            customView(Icons.privacy_tip_outlined,cardColors[4], DI<StringConst>().privacy_policy_text, (){
              var data = {
                "url": "https://policies.google.com/privacy?hl=en",
                "screenType": "Privacy Policy",
              };
               Get.toNamed(
                  DI<RouteHelper>().getWebViewScreen(),
                  parameters: data);

            }),
            SizedBox(
              height: 10,
            ),
            customView(Icons.privacy_tip_outlined,cardColors[5], DI<StringConst>().terms_conditions_text, (){
              var data = {
                "url": "https://shaadiviha.com/terms-and-conditions",
                "screenType": "Terms & Conditions",
              };
             Get.toNamed(
                  DI<RouteHelper>().getWebViewScreen(),
                  parameters: data);

            }),
            SizedBox(
              height: 10,
            ),


          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight+10,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
        child: DI<CommonWidget>().myButton(DI<StringConst>().logout_text,(){
          DI<MyLocalStorage>().clearLocalStorage();
          Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
        }),
      ),
    );
  }


  /// Profile row
  Widget customView(IconData icon,Color myColor, String text, void Function() onTap) {
    return Card(
      color: DI<ColorConst>().gryColor,//myColor.withOpacity(0.5),
      elevation: 1.0,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Icon(
              icon,
              color: DI<ColorConst>().secondColorPrimary,
            ),
            title: Text(text,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().secondColorPrimary,
                    15.sp,
                    FontWeight.w400)),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              size: 17,
              color: DI<ColorConst>().secondColorPrimary,
            ),
          ),
        ),
      ),
    );
  }

}
