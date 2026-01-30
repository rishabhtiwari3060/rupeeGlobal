import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
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

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Invest ₹$startInvest with the interest rate $interestRate% per year during $durationCtrl months",
                maxLines: 3,
                style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().secondColorPrimary, 16.sp, FontWeight.w400),),
              const SizedBox(height: 20),

              Text(
                "End Balance",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                result.endBalance.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _info("Contribution", result.totalContribution),
                  _info("Profit", result.profit),
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
                        color: Colors.red.shade200,
                        radius: 45,
                      ),
                      PieChartSectionData(
                        value: profitPercent,
                        title: "${profitPercent.toStringAsFixed(1)}%",
                        color: Colors.red,
                        radius: 45,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}