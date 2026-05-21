import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:rupeeglobal/util/local_storage.dart';
import 'package:sizer/sizer.dart';

import '../../util/BeepDot.dart';
import '../../util/ColorConst.dart';
import '../../util/CommonFunction.dart';
import '../../util/CommonWidget.dart';
import '../../util/FixedRangeIndicator.dart';
import '../../util/ImageConst.dart';
import '../../util/Injection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeTabController _ctrl = Get.find<HomeTabController>();


  @override
  void initState() {
    super.initState();
    print("token :-- ${DI<MyLocalStorage>().getStringValue(DI<MyLocalStorage>().authToken)}");
    Future.delayed(Duration.zero, () => _ctrl.getMarketIndices());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DI<StringConst>().home_text)),
      body: Obx(
        () =>  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopTabs(),
            Expanded(
              child: Obx(() {
                final isMarketIndices = _ctrl.selectedHomeTab.value == 0;
                final list = isMarketIndices
                    ? (_ctrl.marketIndicesModel.value?.data ?? [])
                    : (_ctrl.forexPairsModel.value?.data ?? []);
                return SingleChildScrollView(
                  child: list.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(
                            child: Text("No data yet", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 16, FontWeight.w500)),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) => _buildIndexCard(list[i]),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabs() {
    return Container(
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          _tabItem(DI<StringConst>().market_indices_text, 0, _ctrl.selectedHomeTab),
          SizedBox(width: 4),
          _tabItem(DI<StringConst>().forex_pairs_text, 1, _ctrl.selectedHomeTab),
        ],
      ),
    );
  }

  /// ─── Generic Tab Item ────────────────────────────
  Widget _tabItem(String label, int index, RxInt selected) {
    final isSelected = selected.value == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          _ctrl.selectedHomeTab.value = index;
          if (selected.value == 1 && _ctrl.forexPairsModel.value == null) _ctrl.getForexPairs();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? DI<ColorConst>().secondColorPrimary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: DI<CommonWidget>().myTextStyle(
                isSelected
                    ? Colors.white
                    : DI<ColorConst>().blackColor,
                12.sp,
                FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndexCard(dynamic item) {
    final isNegative = (item.change ?? 0) < 0 || (item.changePercent ?? 0) < 0;
    final changeColor = isNegative ? DI<ColorConst>().redColor : DI<ColorConst>().dark_greenColor;
    final changeText = isNegative
        ? "${item.change} (${item.changePercent}%)"
        : "+${item.change} (+${item.changePercent}%)";
    final isMarketIndex = _ctrl.selectedHomeTab.value == 0;
    return InkWell(
      onTap: () => Get.toNamed(
        DI<RouteHelper>().getChartScreen(),
        arguments: {
          'symbol': item.symbol,
          'name': item.name,
          'isMarketIndex': isMarketIndex,
        },
      ),
      child: Card(
        color: DI<ColorConst>().whiteColor,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name, style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 15, FontWeight.w500)),
                  Row(children: [BeepDot(), SizedBox(width: 6), Text("Live", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 15, FontWeight.w500))]),
                ],
              ),
              SizedBox(height: 10),
              Text(DI<CommonFunction>().formatPrice(item.price, decimalPlaces: 2), style: DI<CommonWidget>().myTextStyle(changeColor, 20, FontWeight.w500)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(isNegative ? Icons.arrow_downward : Icons.arrow_upward, color: changeColor, size: 17),
                  SizedBox(width: 3),
                  Text(changeText, style: DI<CommonWidget>().myTextStyle(changeColor, 17, FontWeight.w500)),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: DI<ColorConst>().dividerColor, thickness: 0.6),
              SizedBox(height: 10),
              Text("Day's High/Low", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 11, FontWeight.w400)),
              FixedRangeIndicator(min: item.low, max: item.high, value: item.price),
              SizedBox(height: 10),
              Divider(color: DI<ColorConst>().dividerColor, thickness: 0.6),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Open", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 11, FontWeight.w400)),
                Text("Previous Close", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 11, FontWeight.w400)),
              ]),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("${item.open}", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 15, FontWeight.w500)),
                Text("${item.previousClose}", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 15, FontWeight.w500)),
              ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("High", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 11, FontWeight.w400)),
                Text("Low", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 11, FontWeight.w400)),
              ]),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("${item.high}", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().dark_greenColor, 15, FontWeight.w500)),
                Text("${item.low}", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().redColor, 15, FontWeight.w500)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
