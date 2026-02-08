import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';


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

  HomeTabController homeTabController = Get.find<HomeTabController>();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();

    Future.delayed(Duration.zero,() {
      homeTabController.getPortfolio();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Obx(
          () => homeTabController.isLoading.value?SizedBox(): Column(
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
                    child: cardOutLineView("Total Invested","₹${homeTabController.portfolioModel.value?.data.portfolio.totalInvested}",DI<ColorConst>().blackColor),
                  ),
                  Expanded(
                    child: cardOutLineView("Current Value","₹${homeTabController.portfolioModel.value?.data.portfolio.totalValue}",DI<ColorConst>().blackColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: cardOutLineView("Total P&L","₹${homeTabController.portfolioModel.value?.data.portfolio.totalPnl}",DI<ColorConst>().dark_greenColor),
                  ),
                  Expanded(
                    child: cardOutLineView("P&L %","${homeTabController.portfolioModel.value?.data.portfolio.pnlPercent}%",DI<ColorConst>().dark_greenColor),
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
                    child: cardOutLineView("Today","₹${homeTabController.portfolioModel.value?.data.profitLoss.total}",DI<ColorConst>().dark_greenColor),
                  ),
                  Expanded(
                    child: cardOutLineView("This Week","₹${homeTabController.portfolioModel.value?.data.profitLoss.week}",DI<ColorConst>().dark_greenColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: cardOutLineView("This Month","₹${homeTabController.portfolioModel.value?.data.profitLoss.month}",DI<ColorConst>().dark_greenColor),
                  ),
                  Expanded(
                    child: cardOutLineView("This Year","₹${homeTabController.portfolioModel.value?.data.profitLoss.year}",DI<ColorConst>().dark_greenColor),
                  ),
                ],
              ),
             /* SizedBox(
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
              ),*/

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
                          "₹ ${homeTabController.portfolioModel.value?.data.funds.today.added}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().dark_greenColor,
                              15,
                              FontWeight.w400),),

                        Text(
                          "₹ ${homeTabController.portfolioModel.value?.data.funds.month.added}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().dark_greenColor,
                              15,
                              FontWeight.w400),),


                        Text(
                          "₹ ${homeTabController.portfolioModel.value?.data.funds.year.added}",
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
                          "₹ ${homeTabController.portfolioModel.value?.data.funds.today.withdrawn}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().redColor,
                              15,
                              FontWeight.w400),),

                        Text(
                          "₹ ${homeTabController.portfolioModel.value?.data.funds.month.withdrawn}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().redColor,
                              15,
                              FontWeight.w400),),


                        Text(
                          "₹ ${homeTabController.portfolioModel.value?.data.funds.year.withdrawn}",
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
                          "₹ ${(homeTabController.portfolioModel.value?.data.funds.today.added??0 + (homeTabController.portfolioModel.value?.data.funds.today.withdrawn??0) )}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().dark_greenColor,
                              15,
                              FontWeight.w400),),

                        Text(
                          "₹ ${(homeTabController.portfolioModel.value?.data.funds.month.added??0 + homeTabController.portfolioModel.value!.data.funds.month.withdrawn )}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().dark_greenColor,
                              15,
                              FontWeight.w400),),


                        Text(
                          "₹ ${(homeTabController.portfolioModel.value?.data.funds.year.added??0 + homeTabController.portfolioModel.value!.data.funds.year.withdrawn )}",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().dark_greenColor,
                              15,
                              FontWeight.w400),),
                      ],
                    ),
                  ),
                ],
              ),


              SizedBox(
                height: 10,
              ),
              Text(
                "Trade Statistics",
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor,
                    20,
                    FontWeight.w500),
              ),
              Row(
                children: [
                  Expanded(
                    child: cardOutLineView("Total Positions","₹${homeTabController.portfolioModel.value?.data.trades.total}",DI<ColorConst>().blackColor),
                  ),
                  Expanded(
                    child: cardOutLineView("Profitable","₹${homeTabController.portfolioModel.value?.data.trades.winning}",DI<ColorConst>().dark_greenColor),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: cardOutLineView("Loss Making","₹${homeTabController.portfolioModel.value?.data.trades.losing}",DI<ColorConst>().redColor),
                  ),
                  Expanded(
                    child: cardOutLineView("Success Rate","${homeTabController.portfolioModel.value?.data.trades.winRate}%",DI<ColorConst>().blackColor),
                  ),
                ],
              ),

              Text(
                "Charges & Fees",
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor,
                    20,
                    FontWeight.w500),
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: (homeTabController.portfolioModel.value?.data.charges.length??0)+1,
                itemBuilder: (context, index) {
                  var listData = homeTabController.portfolioModel.value?.data.charges;
                  return Card(
                    color: DI<ColorConst>().whiteColor,
                    elevation: 0.0,
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color:Colors.transparent)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: index < homeTabController.portfolioModel.value!.data.charges.length?
                        Column(
                        spacing: 5,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex:0,
                                child: Text(
                                  "Charge Type :",
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
                                  "${listData?[index].chargeType}",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().blackColor,
                                      16,
                                      FontWeight.w600),
                                ),
                              ),
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Date :",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "${listData?[index].date}",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().secondColorPrimary,
                                    16,
                                    FontWeight.w500),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                flex:0,
                                child: Text(
                                  "Amount :",
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
                                  "₹ ${listData?[index].amount}",
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
                                  "Note :",
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
                                  "${listData?[index].note}",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().blackColor,
                                      16,
                                      FontWeight.w500),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ) :Row(
                        children: [
                          Expanded(
                            flex:0,
                            child: Text(
                              "Total Charges :",
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
                              "${homeTabController.portfolioModel.value!.data.totalCharges}",
                              style: DI<CommonWidget>().myTextStyle(
                                  DI<ColorConst>().blackColor,
                                  16,
                                  FontWeight.w600),
                            ),
                          ),
                        ],
                      )

                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 7,
                );
              },)
            ],
          ),
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
