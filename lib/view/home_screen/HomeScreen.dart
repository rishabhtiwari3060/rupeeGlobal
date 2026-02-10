import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../util/BeepDot.dart';
import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/FixedRangeIndicator.dart';
import '../../util/Injection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeTabController homeTabController = Get.find<HomeTabController>();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    print("token :-- ${DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken)}");

    Future.delayed(Duration.zero,() {
      homeTabController.getMarketIndices();
    },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(DI<StringConst>().market_indices_text,
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      20,
                      FontWeight.w500),),
              ),
            ),

            SizedBox(
              width: 5,
            ),

            Expanded(
              flex: 1,
              child: Center(
                child: Text("",//DI<StringConst>().forex_pairs_text,
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().blackColor,
                      20,
                      FontWeight.w500),),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () =>  Column(
            children: [
          marketIndicesColumn()
            ],
          ),
        ),
      ),
    );
  }

  Widget marketIndicesColumn(){
    return Column(
      children: [
       ListView.builder(
         shrinkWrap: true,
         itemCount: homeTabController.marketIndicesModel.value?.data.length??0,
         physics: NeverScrollableScrollPhysics(),
         itemBuilder: (context, index) {
         return  InkWell(
           onTap: (){
             Get.toNamed(DI<RouteHelper>().getChartScreen());
           },
           child: Card(
             color: DI<ColorConst>().whiteColor,
             elevation: 0.5,
             shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(7)),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("${homeTabController.marketIndicesModel.value?.data[index].name}", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().blackColor,
                           15,
                           FontWeight.w500),),

                       Row(
                         children: [
                           BeepDot(),
                           SizedBox(width: 6),
                           Text("Live",style: DI<CommonWidget>().myTextStyle(
                               DI<ColorConst>().blackColor,
                               15,
                               FontWeight.w500),),
                         ],
                       ),

                     ],
                   ),
                   SizedBox(height: 10,),
                   Text("${homeTabController.marketIndicesModel.value?.data[index].price}", style: DI<CommonWidget>().myTextStyle(
                       DI<ColorConst>().dark_greenColor,
                       20,
                       FontWeight.w500),),
                   SizedBox(height: 5,),
                   Row(
                     children: [
                       Icon(Icons.arrow_upward,color:  DI<ColorConst>().dark_greenColor,size: 17,),
                       SizedBox(width: 3,),
                       Text("+${homeTabController.marketIndicesModel.value?.data[index].change} (+${homeTabController.marketIndicesModel.value?.data[index].changePercent}%)", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().dark_greenColor,
                           17,
                           FontWeight.w500),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Divider(),
                   SizedBox(height: 10,),
                   Text("Day's High/Low", style: DI<CommonWidget>().myTextStyle(
                       DI<ColorConst>().darkGryColor,
                       11,
                       FontWeight.w400),),

                   FixedRangeIndicator(
                     min: double.parse(homeTabController.marketIndicesModel.value?.data[index].low.toString()??"0.0"),
                     max: double.parse(homeTabController.marketIndicesModel.value?.data[index].high.toString()??"0.0"),
                     value: double.parse(homeTabController.marketIndicesModel.value?.data[index].price.toString()??"0.0"),
                   ),

                   SizedBox(height: 10,),
                   Divider(),
                   SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Open", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().darkGryColor,
                           11,
                           FontWeight.w400),),

                       Text("Previous Close", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().darkGryColor,
                           11,
                           FontWeight.w400),),
                     ],
                   ),
                   SizedBox(height: 5,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("${homeTabController.marketIndicesModel.value?.data[index].open}", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().blackColor,
                           15,
                           FontWeight.w500),),

                       Text("${homeTabController.marketIndicesModel.value?.data[index].previousClose}", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().blackColor,
                           15,
                           FontWeight.w500),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("High", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().darkGryColor,
                           11,
                           FontWeight.w400),),

                       Text("Low", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().darkGryColor,
                           11,
                           FontWeight.w400),),
                     ],
                   ),
                   SizedBox(height: 5,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("${homeTabController.marketIndicesModel.value?.data[index].high}", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().dark_greenColor,
                           15,
                           FontWeight.w500),),

                       Text("${homeTabController.marketIndicesModel.value?.data[index].low}", style: DI<CommonWidget>().myTextStyle(
                           DI<ColorConst>().redColor,
                           15,
                           FontWeight.w500),),
                     ],
                   ),
                 ],
               ),
             ),
           ),
         );
       },)
      ],
    );
  }
}
