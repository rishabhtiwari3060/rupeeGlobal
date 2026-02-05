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
        () => SingleChildScrollView(
          child: Column(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: holdingContainer("Total Invested", "₹ 2,22,500",DI<ColorConst>().blackColor)),
            SizedBox(
              width: 4,
            ),
            Expanded(
                flex: 1,
                child: holdingContainer("Total Value", "₹ 2,31,000",DI<ColorConst>().blackColor)),
            SizedBox(
              width: 4,
            ),
            Expanded(
                flex: 1,
                child: holdingContainer("Margin", "₹ 8,500",DI<ColorConst>().dark_greenColor)),
          ],
        ),
    SizedBox(
    height: 10,
    ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              color: DI<ColorConst>().whiteColor,
              margin: EdgeInsets.symmetric(horizontal: 5),
              elevation: 0.3,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color:Colors.transparent)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  spacing: 5,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex:0,
                          child: Text(
                            "Symbol :",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().darkGryColor,
                                15,
                                FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          flex:1,
                          child: Text(
                            "SENSEX 84800 CE",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().blackColor,
                                16,
                                FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex:0,
                          child: Text(
                            "Company Name :",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().darkGryColor,
                                15,
                                FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          flex:1,
                          child: Text(
                            "Testing Ebussiness",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().blackColor,
                                16,
                                FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                flex:0,
                                child: Text(
                                  "Quantity :",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().darkGryColor,
                                      15,
                                      FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                flex:1,
                                child: Text(
                                  "1000",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().blackColor,
                                      16,
                                      FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Avg Price :",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "₹ 200",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().blackColor,
                                    16,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                flex:0,
                                child: Text(
                                  "LTP :",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().darkGryColor,
                                      15,
                                      FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                flex:1,
                                child: Text(
                                  "₹ 210",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().blackColor,
                                      16,
                                      FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Current Value :",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "₹ 2,10,000",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().blackColor,
                                    16,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex:0,
                                child: Text(
                                  "P&L :",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().darkGryColor,
                                      15,
                                      FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                flex:1,
                                child: Text(
                                  "₹ 10,000",
                                  style: DI<CommonWidget>().myTextStyle(
                                      index %2==0?
                                      DI<ColorConst>().dark_greenColor:
                                      DI<ColorConst>().redColor,
                                      16,
                                      FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "P&L % :",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "5.00%",
                                style: DI<CommonWidget>().myTextStyle(
                                  index %2==0?
                                    DI<ColorConst>().dark_greenColor:
                                  DI<ColorConst>().redColor,
                                    16,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
        },)

      ],
    );
  }


  Widget regularColumn(){
    return Column(
      children: [

        Row(
          children: [
            Expanded(
                flex: 1,
                child: positionsContainer("Day's P&L", "6,000")),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: positionsContainer("Overall P&L", "6,000")),
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Closed (1)",
                  style: DI<CommonWidget>().myTextStyle(
                       DI<ColorConst>().blackColor,
                      20,
                      FontWeight.w500),
                ),

                SizedBox(
                  height: 5.0,
                ),

                Card(
                  color: DI<ColorConst>().whiteColor,
                  margin: EdgeInsets.zero,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color:Colors.transparent)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "SENSEX 84800 CE",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().blackColor,
                                  18,
                                  FontWeight.w500),
                            ),

                            Text(
                              "₹ 1,000",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().dark_greenColor,
                                  18,
                                  FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "27 Feb 2026 · Qty 100",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().darkGryColor,
                                  15,
                                  FontWeight.w400),
                            ),

                            Text(
                              "(5.00%)",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().dark_greenColor,
                                  15,
                                  FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Divider(),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Buy ₹ 200",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().darkGryColor,
                                 15,
                                  FontWeight.w400),
                            ),

                            Text(
                              "Sell ₹ 210",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().darkGryColor,
                                  15,
                                  FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },)

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
                child: positionsContainer("Day's P&L", "₹ 5,000")),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: positionsContainer("Overall P&L", "₹ 5,000")),
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Positions",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().blackColor,
                        20,
                        FontWeight.w500),
                  ),

                  SizedBox(
                    height: 5.0,
                  ),

                  Card(
                    color: DI<ColorConst>().whiteColor,
                    margin: EdgeInsets.zero,
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color:Colors.transparent)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "SENSEX 84800 CE",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().blackColor,
                                    18,
                                    FontWeight.w500),
                              ),

                              Text(
                                "₹ 1,000",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().dark_greenColor,
                                    18,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "27 Feb 2026 · Qty 100",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w400),
                              ),

                              Text(
                                "(5.00%)",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().dark_greenColor,
                                    15,
                                    FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Divider(),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buy ₹ 200",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w400),
                              ),

                              Text(
                                "Sell ₹ 210",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },)
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
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Closed (1)",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().blackColor,
                        20,
                        FontWeight.w500),
                  ),

                  SizedBox(
                    height: 5.0,
                  ),

                  Card(
                    color: DI<ColorConst>().whiteColor,
                    margin: EdgeInsets.zero,
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color:Colors.transparent)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "SENSEX 84800 CE",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().blackColor,
                                    18,
                                    FontWeight.w500),
                              ),

                              Text(
                                "₹ 1,000",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().dark_greenColor,
                                    18,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "27 Feb 2026 · Qty 100",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w400),
                              ),

                              Text(
                                "(5.00%)",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().dark_greenColor,
                                    15,
                                    FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Divider(),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buy ₹ 200",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w400),
                              ),

                              Text(
                                "Sell ₹ 210",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },)
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

  Widget holdingContainer(String title, String amount,Color textColor){
    return   Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.transparent,
         border: Border.all(color: DI<ColorConst>().darkGryColor)
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
                textColor,
               15,
                FontWeight.w700),),
        ],
      ),
    );
  }
}
