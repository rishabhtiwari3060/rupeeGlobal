import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import 'CompoundResult.dart';


class CompoundResultScreen extends StatelessWidget {
  final CompoundResult result;
  final double startInvest,interestRate;
      final int durationCtrl;

  const CompoundResultScreen({super.key, required this.result,
    required this.startInvest,required this.interestRate,required this.durationCtrl});

  @override
  Widget build(BuildContext context) {
    final contributionPercent =
        (result.totalContribution / result.endBalance) * 100;
    final profitPercent = 100 - contributionPercent;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Invest ₹${DI<CommonFunction>().formatPrice(startInvest)} with the interest rate $interestRate% per year during $durationCtrl months",
                  maxLines: 3,
                  style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().secondColorPrimary, 16.sp, FontWeight.w400),),
                const SizedBox(height: 20),
      
                Text(
                  "End Balance",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  DI<CommonFunction>().formatPrice(result.endBalance, decimalPlaces: 2),
                  style:  TextStyle(
                    fontSize: 32,
                    color: DI<ColorConst>().blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _info("Contribution", result.totalContribution,DI<ColorConst>().blackColor),
                    _info("Profit", result.profit,DI<ColorConst>().dark_greenColor),
                  ],
                ),
      
                const SizedBox(height: 40),
      
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 70,
                      sections: [
                        PieChartSectionData(
                          value: contributionPercent,
                          title: "${contributionPercent.toStringAsFixed(1)}%",
                          color: DI<ColorConst>().redColor.withOpacity(0.6),
                          radius: 45,
                        ),
                        PieChartSectionData(
                          value: profitPercent,
                          title: "${profitPercent.toStringAsFixed(1)}%",
                          color: DI<ColorConst>().dark_greenColor,
                          radius: 45,
                        ),
                      ],
                    ),
                  ),
                ),
      
      
                buildTable(result.monthWiseData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _info(String label, double value,Color textColor) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: DI<ColorConst>().darkGryColor)),
        const SizedBox(height: 4),
        Text(
          DI<CommonFunction>().formatPrice(value, decimalPlaces: 2),
          style:  TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget buildTable(List<MonthGrowth> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 25,
        headingRowColor:
        WidgetStateProperty.all(DI<ColorConst>().gryColor),
        columns: const [
          DataColumn(label: Text("Month")),
          DataColumn(label: Text("Interest")),
          DataColumn(label: Text("Contribution")),
          DataColumn(label: Text("End Balance")),
        ],
        rows: data.map((item) {
          return DataRow(
            cells: [
              DataCell(Text("M${item.month}")),
              DataCell(Text("₹${DI<CommonFunction>().formatPrice(item.interest, decimalPlaces: 2)}")),
              DataCell(Text("₹${DI<CommonFunction>().formatPrice(item.contribution, decimalPlaces: 2)}")),
              DataCell(Text("₹${DI<CommonFunction>().formatPrice(item.endBalance, decimalPlaces: 2)}")),
            ],
          );
        }).toList(),
      ),
    );
  }
}