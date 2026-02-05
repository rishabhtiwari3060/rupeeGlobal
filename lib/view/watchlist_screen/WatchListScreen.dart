import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  var selectType = 0.obs;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Obx(
          () =>  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                DI<StringConst>().funds_balance_text,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor,
                    20,
                    FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),

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
                            DI<StringConst>().funds_text,
                            style: DI<CommonWidget>().myTextStyle(
                                selectType.value == 0
                                    ? DI<ColorConst>().redColor
                                    : DI<ColorConst>().blackColor,
                                17,
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
                            DI<StringConst>().add_fund_text,
                            style: DI<CommonWidget>().myTextStyle(
                                selectType.value == 1
                                    ? DI<ColorConst>().redColor
                                    : DI<ColorConst>().blackColor,
                                17,
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
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        selectType.value = 2;
                      },
                      child: Column(
                        children: [
                          Text(
                            DI<StringConst>().withdraw_funds_text,
                            style: DI<CommonWidget>().myTextStyle(
                                selectType.value == 2
                                    ? DI<ColorConst>().redColor
                                    : DI<ColorConst>().blackColor,
                                17,
                                FontWeight.w500),
                          ),
                          Divider(
                            color: selectType.value == 2
                                ? DI<ColorConst>().redColor
                                : DI<ColorConst>().whiteColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              if(selectType.value == 0)
                fundColumn(),

              if(selectType.value == 1)
                addFundColumn(),

              if(selectType.value == 2)
                withdrawFundColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fundColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: fundContainer("Available Balance", "₹ 1,000",DI<ColorConst>().dark_greenColor)),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: fundContainer("Margin", "5X",DI<ColorConst>().blackColor)),

            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: fundContainer("Total Funds", "₹ 5,000",DI<ColorConst>().blackColor)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          DI<StringConst>().transaction_history_text,
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().blackColor,
              20,
              FontWeight.w500),
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
                            "Date :",
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
                            "04 Feb 2026, 11:45 AM",
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().blackColor,
                                16,
                                FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                 

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Position :",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().darkGryColor,
                              15,
                              FontWeight.w500),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "NIFTY 25000 PE",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().blackColor,
                              16,
                              FontWeight.w500),
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
                                  "₹ 5,000",
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
                              Expanded(
                                flex:0,
                                child: Text(
                                  "Type :",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().darkGryColor,
                                      15,
                                      FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                flex:0,
                                child: Text(
                                  "Credit",
                                  style: DI<CommonWidget>().myTextStyle(
                                      DI<ColorConst>().dark_greenColor,
                                      16,
                                      FontWeight.w500),
                                ),
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
                                  "Profit",
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
                                "Status :",
                                style: DI<CommonWidget>().myTextStyle(
                                    DI<ColorConst>().darkGryColor,
                                    15,
                                    FontWeight.w500),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "Success",
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

  Widget addFundColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          DI<StringConst>().request_add_fund_text,
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().blackColor,
              20,
              FontWeight.w500),
        ),


        SizedBox(
          height: 7.w,
        ),

        Text(DI<StringConst>().amount_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
        DI<CommonWidget>().myTextFormField(
            textInputType: TextInputType.number,
            "",
            textInputAction:TextInputAction.next),
        SizedBox(
          height: 10,
        ),
        Text(DI<StringConst>().notes_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
        DI<CommonWidget>().myTextFormField(
            textInputType: TextInputType.text,
            "",
        minLine: 5,
        textInputAction:TextInputAction.done),
        SizedBox(
          height: 15.w,
        ),

        DI<CommonWidget>().myButton(DI<StringConst>().submit_fund_request_text,(){}),
      ],
    );
  }

  Widget withdrawFundColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Text(
          DI<StringConst>().request_withdraw_fund_text,
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().blackColor,
              20,
              FontWeight.w500),
        ),

        SizedBox(
          height: 7.w,
        ),

        Text(
          "${DI<StringConst>().available_balance_text} ₹1,000.00",
          style: DI<CommonWidget>().myTextStyle(
              DI<ColorConst>().dark_greenColor,
              15,
              FontWeight.w700),
        ),

        SizedBox(
          height: 7,
        ),
        Text(DI<StringConst>().amount_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
        DI<CommonWidget>().myTextFormField(
            textInputType: TextInputType.number,
            "",
            textInputAction:TextInputAction.next),
        SizedBox(
          height: 10,
        ),

        Text(DI<StringConst>().upi_id_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
        DI<CommonWidget>().myTextFormField(
            textInputType: TextInputType.text,
            "",
            textInputAction:TextInputAction.next),
        SizedBox(
          height: 10,
        ),

        Text(DI<StringConst>().upi_name_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
        DI<CommonWidget>().myTextFormField(
            textInputType: TextInputType.text,
            "",
            textInputAction:TextInputAction.next),
        SizedBox(
          height: 10,
        ),
        Text(DI<StringConst>().notes_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 13.sp, FontWeight.w400),),
        DI<CommonWidget>().myTextFormField(
            textInputType: TextInputType.text,
            "",
            minLine: 5,
            textInputAction:TextInputAction.done),
        SizedBox(
          height: 15.w,
        ),

        DI<CommonWidget>().myButton(DI<StringConst>().submit_withdrawal_request_text,(){}),
      ],
    );
  }


  Widget fundContainer(String title, String amount,Color textColor){
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
