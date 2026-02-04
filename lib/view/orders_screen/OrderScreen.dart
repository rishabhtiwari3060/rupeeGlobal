import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var selectType = 0.obs;
  var selectHoldingType = 0.obs;
  var selectPositionType = 0.obs;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      selectType.value = 0;
                    },
                    child: Column(
                      children: [
                        Text(
                          DI<StringConst>().positions_text,
                          style: DI<CommonWidget>().myTextStyle(
                              selectType.value == 0
                                  ? DI<ColorConst>().redColor
                                  : DI<ColorConst>().blackColor,
                              20,
                              FontWeight.w500),
                        ),
                        Divider(
                          color: selectType.value == 0
                              ? DI<ColorConst>().redColor
                              : DI<ColorConst>().whiteColor,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      selectType.value = 1;
                    },
                    child: Column(
                      children: [
                        Text(
                          DI<StringConst>().holdings_text,
                          style: DI<CommonWidget>().myTextStyle(
                              selectType.value == 1
                                  ? DI<ColorConst>().redColor
                                  : DI<ColorConst>().blackColor,
                              20,
                              FontWeight.w500),
                        ),
                        Divider(
                          color: selectType.value == 1
                              ? DI<ColorConst>().redColor
                              : DI<ColorConst>().whiteColor,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            selectType.value == 0 ? positionsColumn() : holdingColumn(),
          ],
        ),
      ),
    );
  }

  Widget positionsColumn() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  selectPositionType.value = 0;
                },
                child: Column(
                  children: [
                    Text(
                      "${DI<StringConst>().regular_text} (0)",
                      style: DI<CommonWidget>().myTextStyle(
                          selectPositionType.value == 0
                              ? DI<ColorConst>().secondColorPrimary
                              : DI<ColorConst>().blackColor,
                          18,
                          FontWeight.w500),
                    ),
                    Divider(
                      color: selectPositionType.value == 0
                          ? DI<ColorConst>().secondColorPrimary
                          : DI<ColorConst>().whiteColor,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  selectPositionType.value = 1;
                },
                child: Column(
                  children: [
                    Text(
                      "${DI<StringConst>().mtf_text} (0)",
                      style: DI<CommonWidget>().myTextStyle(
                          selectPositionType.value == 1
                              ? DI<ColorConst>().secondColorPrimary
                              : DI<ColorConst>().blackColor,
                          18,
                          FontWeight.w500),
                    ),
                    Divider(
                      color: selectPositionType.value == 1
                          ? DI<ColorConst>().secondColorPrimary
                          : DI<ColorConst>().whiteColor,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  selectPositionType.value = 2;
                },
                child: Column(
                  children: [
                    Text(
                      "${DI<StringConst>().strategy_text} (0)",
                      style: DI<CommonWidget>().myTextStyle(
                          selectPositionType.value == 2
                              ? DI<ColorConst>().secondColorPrimary
                              : DI<ColorConst>().blackColor,
                          18,
                          FontWeight.w500),
                    ),
                    Divider(
                      color: selectPositionType.value == 2
                          ? DI<ColorConst>().secondColorPrimary
                          : DI<ColorConst>().whiteColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        if(selectPositionType.value == 0)
          regularColumn(),
        if(selectPositionType.value == 1)
          mtfColumn(),
        if(selectPositionType.value == 2)
          strategyColumn(),
      ],
    );
  }

  Widget holdingColumn() {
    return Column(
      children: [Text("holding")],
    );
  }


  Widget regularColumn(){
    return Column(
      children: [

        Row(
          children: [
            Expanded(
                flex: 1,
                child: positionsContainer("Day's P&L", "0")),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: positionsContainer("Overall P&L", "0")),
          ],
        )
      ],
    );
  }

  Widget mtfColumn(){
    return Column(
      children: [

        Row(
          children: [
            Expanded(
                flex: 1,
                child: positionsContainer("Day's P&L", "0")),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: positionsContainer("Overall P&L", "0")),
          ],
        )
      ],
    );
  }

  Widget strategyColumn(){
    return Column(
      children: [

        Row(
          children: [
            Expanded(
                flex: 1,
                child: positionsContainer("Day's P&L", "0")),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: positionsContainer("Overall P&L", "0")),
          ],
        )
      ],
    );
  }


  Widget positionsContainer(String title, String amount){
    return   Container(
      padding: EdgeInsets.all(13.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: DI<ColorConst>().gryColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor,
                14,
                FontWeight.w400),),
          SizedBox(
            height: 3,
          ),

          Text("₹ $amount",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().dark_greenColor,
                20,
                FontWeight.w700),),
        ],
      ),
    );
  }
}
