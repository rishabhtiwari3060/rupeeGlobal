import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {


  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: DI<ColorConst>().blackColor,
            )),
        title: Text(
          "NIFTY Chart",
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "83,580.40",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                      Text("+266.47 (+0.32%)",
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                InkWell(
                  onTap: (){
                    showOptionChainDialog();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    decoration:BoxDecoration(
                        border: Border.all(color: DI<ColorConst>().redColor,
                            width: 2),
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child:   Text(DI<StringConst>().option_chain_text,
                      style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().redColor, 15.sp, FontWeight.w400),),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: ["1D", "1W", "1M", "1Y", "ALL"].map((e) {
                final selected = e == "1D";
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(e),
                    selected: selected,
                    selectedColor: Colors.red,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 7),
            SizedBox(
              height: 60.h,
              child: SingleChildScrollView(

                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 300.w, // 👈 controls scroll length
                  child: LineChartWidget(),
                ),
              ),
            ),

        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            _statItem("OPEN", "83,234.05",Colors.black),
            _statItem("HIGH", "83,612.12", Colors.green),
            _statItem("LOW", "82,925.35", Colors.red),
            _statItem("PREV CLOSE", "83,313.93",Colors.black),
          ],
        )
        
          ],
        ),
      ),

    );
  }

  Widget _statItem(  String title, String value,Color color){
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void showOptionChainDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    "Option Chain Access",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Message
                  const Text(
                    "You cannot access this feature. Please contact the company to enable Option Chain access.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // OK Button
                  SizedBox(
                    width: 120,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: Get.back,
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Close Button
            Positioned(
              right: 12,
              top: 12,
              child: InkWell(
                onTap: Get.back,
                child: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

}




class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 82600,
        maxY: 84400,

        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, _) {
                return Text("${value.toInt()}:00");
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.15),
            ),
            dotData: FlDotData(show: false),

            spots: [
              FlSpot(1, 83000),
              FlSpot(3, 83800),
              FlSpot(5, 83200),
              FlSpot(7, 84200),
              FlSpot(9, 83050),
              FlSpot(11, 83500),
              FlSpot(13, 82900),
              FlSpot(15, 84300),
              FlSpot(17, 83400),
              FlSpot(19, 83900),
              FlSpot(21, 82850),
              FlSpot(23, 83200),
            ],
          ),
        ],

        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  "₹${spot.y.toStringAsFixed(2)}",
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
