import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DI<StringConst>().portfolio_summary_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  20,
                  FontWeight.w500),
            ),
            Row(
              children: [
                Expanded(
                  child: cardOutLineView("Total Invested","₹35,000",DI<ColorConst>().blackColor),
                ),
                Expanded(
                  child: cardOutLineView("Current Value","₹41,000",DI<ColorConst>().blackColor),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: cardOutLineView("Total P&L","₹6,000",DI<ColorConst>().dark_greenColor),
                ),
                Expanded(
                  child: cardOutLineView("P&L %","17.14%",DI<ColorConst>().dark_greenColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
             "Profit & Loss",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  20,
                  FontWeight.w500),
            ),
            Row(
              children: [
                Expanded(
                  child: cardOutLineView("Today","₹6,000",DI<ColorConst>().dark_greenColor),
                ),
                Expanded(
                  child: cardOutLineView("This Week","₹6,000",DI<ColorConst>().dark_greenColor),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: cardOutLineView("This Month","₹6,000",DI<ColorConst>().dark_greenColor),
                ),
                Expanded(
                  child: cardOutLineView("This Year","₹6,000",DI<ColorConst>().dark_greenColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Fund Statistics",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  20,
                  FontWeight.w500),
            ),
            Row(
              children: [
                Expanded(
                  child: cardOutLineView("Current Balance","₹1,000",DI<ColorConst>().dark_greenColor),
                ),
                Expanded(
                  child: cardOutLineView("Total Added","₹0",DI<ColorConst>().dark_greenColor),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: cardOutLineView("Total Withdrawn","₹0",DI<ColorConst>().redColor),
                ),
                Expanded(
                  child: cardOutLineView("Net Deposit","0",DI<ColorConst>().dark_greenColor),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              "Fund Flow",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  20,
                  FontWeight.w500),
            ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Period",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor,
                            17,
                            FontWeight.w700),
                      ),

                  Text(
                    "Today",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().blackColor,
                        15,
                        FontWeight.w400),),

                      Text(
                        "This Month",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().blackColor,
                            15,
                            FontWeight.w400),),


                      Text(
                        "This Year",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().blackColor,
                            15,
                            FontWeight.w400),),




                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        "Added",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor,
                            17,
                            FontWeight.w700),
                      ),

                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().dark_greenColor,
                            15,
                            FontWeight.w400),),

                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().dark_greenColor,
                            15,
                            FontWeight.w400),),


                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().dark_greenColor,
                            15,
                            FontWeight.w400),),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        "Withdrawn",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor,
                            17,
                            FontWeight.w700),
                      ),

                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().redColor,
                            15,
                            FontWeight.w400),),

                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().redColor,
                            15,
                            FontWeight.w400),),


                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().redColor,
                            15,
                            FontWeight.w400),),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        "Net",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor,
                            17,
                            FontWeight.w700),
                      ),

                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().dark_greenColor,
                            15,
                            FontWeight.w400),),

                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().dark_greenColor,
                            15,
                            FontWeight.w400),),


                      Text(
                        "₹ 0",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().dark_greenColor,
                            15,
                            FontWeight.w400),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardOutLineView(String title,String amount,Color textColor){
    return Card(
      elevation: 0.0,
      color: DI<ColorConst>().whiteColor,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: DI<ColorConst>().gryColor,width: 0.8)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor,
                  17,
                  FontWeight.w500),
            ),

            SizedBox(height: 7,),
            Text(
              amount,
              style: DI<CommonWidget>().myTextStyle(
                  textColor,
                  19,
                  FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
