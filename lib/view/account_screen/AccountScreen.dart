import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/util/ColorConst.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../util/CommonWidget.dart';
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

  @override
  void initState() {
   WidgetsFlutterBinding.ensureInitialized();
    super.initState();
   cardColors = List.generate(12, (_) => getLightBrightColor());
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
                      child: CircleAvatar(
                        backgroundColor: DI<ColorConst>().greenColor.withOpacity(0.7),
                        radius: 15.w,
                        child: Text("R",style:  DI<CommonWidget>()
                            .myTextStyle(DI<ColorConst>().redColor, 30.sp, FontWeight.w500),),
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
              height: 15.w,
            ),

            Row(
              children: [
                customView(Icons.support_agent,cardColors[0], DI<StringConst>().support_ticket_text, (){

                  Get.toNamed(DI<RouteHelper>().getSupportTicketScreen());

                }),

                SizedBox(
                  width: 7,
                ),
                customView(Icons.calculate_outlined, cardColors[1],DI<StringConst>().pms_text, (){
                  Get.toNamed(DI<RouteHelper>().getPmsScreen());

                }),
              ],
            ),



            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                customView(Icons.newspaper,cardColors[3], DI<StringConst>().news_text, (){

                  Get.toNamed(DI<RouteHelper>().getNewsScreen());
                }),

                SizedBox(
                  width: 7,
                ),
                Expanded(
                    flex: 1,
                    child: SizedBox())
              ],
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
  Widget customView(
      IconData icon, Color color, String text, void Function() onTap) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: color.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: DI<ColorConst>().darkGryColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().darkGryColor, 15.sp, FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
