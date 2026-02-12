import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

/// Single period OHLCV for candlestick + volume.
class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final String timeLabel;

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.timeLabel,
  });

  bool get isUp => close >= open;
}

/// CPR (Central Pivot Range) level for horizontal band on chart.
class CprLevel {
  final double price;
  final Color color;
  CprLevel(this.price, this.color);
}

class ChartController extends GetxController {
  final selectedTimeframe = 0.obs; // 0=1D, 1=1W, 2=1M, 3=1Y, 4=ALL
}

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late ChartController _chartCtrl;
  final HomeTabController _homeCtrl = Get.find<HomeTabController>();
  
  // Get parameters from route arguments
  late String symbol;
  late String name;
  late bool isMarketIndex; // true = market index, false = forex pair

  @override
  void initState() {
    super.initState();
    _chartCtrl = Get.put(ChartController());
    
    // Get arguments from navigation
    final args = Get.arguments as Map<String, dynamic>?;
    symbol = args?['symbol'] ?? 'SENSEX';
    name = args?['name'] ?? 'SENSEX';
    isMarketIndex = args?['isMarketIndex'] ?? true;
    
    // Fetch detail data based on type
    Future.delayed(Duration.zero, () {
      if(isMarketIndex) {
        _homeCtrl.getMarketIndexDetail(symbol);
      } else {
        _homeCtrl.getForexPairDetail(symbol);
      }
    });
  }

  @override
  void dispose() {
    Get.delete<ChartController>();
    super.dispose();
  }

  List<CandleData> _buildSampleCandles(double price, double open, double high, double low) {
    final list = <CandleData>[];
    final times = ["01:00", "04:00", "07:00", "10:00", "13:00", "16:00", "19:00", "22:00", "00:00"];
    double o = open - 100;
    for (int i = 0; i < times.length; i++) {
      final range = 150.0 + (i % 3) * 80.0;
      final c = o + (i.isEven ? -range * 0.5 : range * 0.4);
      final h = o + range;
      final l = o - range * 0.6;
      list.add(CandleData(
        open: o,
        high: h,
        low: l,
        close: c,
        volume: 1.2 + (i % 4) * 0.8,
        timeLabel: times[i],
      ));
      o = c;
    }
    if (list.isNotEmpty) {
      final last = list.last;
      list[list.length - 1] = CandleData(
        open: open,
        high: high,
        low: low,
        close: price,
        volume: last.volume,
        timeLabel: last.timeLabel,
      );
    }
    return list;
  }

  List<CprLevel> _buildCprLevels(double prevClose) {
    final h = prevClose + 200;
    final l = prevClose - 200;
    final c = prevClose;
    final p = (h + l + c) / 3;
    final r1 = 2 * p - l;
    final s1 = 2 * p - h;
    return [
      CprLevel(r1, DI<ColorConst>().dark_greenColor),
      CprLevel(p, Colors.blue),
      CprLevel(s1, DI<ColorConst>().redColor),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().whiteColor,
      body: SafeArea(
        child: Obx(() {
          // Get data based on type
          double price = 0;
          double change = 0;
          double changePercent = 0;
          double open = 0;
          double high = 0;
          double low = 0;
          double prevClose = 0;
          String displayName = name;
          String categoryLabel = isMarketIndex ? "MARKET INDICES" : "FOREX PAIRS";

          if (isMarketIndex && _homeCtrl.marketIndexDetailModel.value != null) {
            final data = _homeCtrl.marketIndexDetailModel.value!.data;
            price = data.price;
            change = data.change;
            changePercent = data.changePercent;
            open = data.open;
            high = data.high;
            low = data.low;
            prevClose = data.previousClose;
            displayName = data.name;
          } else if (!isMarketIndex && _homeCtrl.forexPairDetailModel.value != null) {
            final data = _homeCtrl.forexPairDetailModel.value!.data;
            price = data.price;
            change = data.change;
            changePercent = data.changePercent;
            open = data.open;
            high = data.high;
            low = data.low;
            prevClose = data.previousClose;
            displayName = data.name;
          }

          // Build candles and CPR levels with current data
          final candles = _buildSampleCandles(price, open, high, low);
          final cprLevels = _buildCprLevels(prevClose);

          final isNegative = change < 0 || changePercent < 0;
          final changeColor = isNegative ? DI<ColorConst>().redColor : DI<ColorConst>().dark_greenColor;
          final changeText = isNegative 
              ? "↓${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)" 
              : "↑+${change.toStringAsFixed(2)} (+${changePercent.toStringAsFixed(2)}%)";

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: back arrow (Get.back) | title | Option Chain
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.only(top: 4, right: 8),
                        child: Icon(Icons.arrow_back_ios, size: 22, color: DI<ColorConst>().blackColor),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(categoryLabel, style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 12, FontWeight.w400)),
                          SizedBox(height: 4),
                          Text("$displayName Chart", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 22, FontWeight.w700)),
                          SizedBox(height: 2),
                          Text("Real-time price chart and analysis.", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 12, FontWeight.w400)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: showOptionChainDialog,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.link, size: 16, color: DI<ColorConst>().darkGryColor),
                            SizedBox(width: 4),
                            Text(DI<StringConst>().option_chain_text, style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().redColor, 13, FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: ["1D", "1W", "1M", "1Y", "ALL"].asMap().entries.map((e) {
                    final sel = _chartCtrl.selectedTimeframe.value == e.key;
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _chartCtrl.selectedTimeframe.value = e.key,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? DI<ColorConst>().redColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: sel ? DI<ColorConst>().redColor : DI<ColorConst>().darkGryColor.withOpacity(0.5)),
                          ),
                          child: Text(e.value, style: DI<CommonWidget>().myTextStyle(sel ? DI<ColorConst>().whiteColor : DI<ColorConst>().blackColor, 13, FontWeight.w500)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                // Symbol label + price + change
                Text(symbol, style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 13, FontWeight.w400)),
                SizedBox(height: 4),
                _homeCtrl.isLoading.value 
                    ? Text("Loading...", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 28, FontWeight.w700))
                    : Text(price.toStringAsFixed(2), style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 28, FontWeight.w700)),
                SizedBox(height: 4),
                _homeCtrl.isLoading.value 
                    ? SizedBox()
                    : Text(changeText, style: DI<CommonWidget>().myTextStyle(changeColor, 15, FontWeight.w500)),
                SizedBox(height: 16),
                // Candlestick + Volume + CPR
                _homeCtrl.isLoading.value
                    ? SizedBox(
                        height: 52.h,
                        child: Center(child: CircularProgressIndicator(color: DI<ColorConst>().secondColorPrimary)),
                      )
                    : SizedBox(
                        height: 52.h,
                        child: CandlestickWithVolume(
                          candles: candles,
                          cprLevels: cprLevels,
                          chartHeight: 32.h,
                          volumeHeight: 14.h,
                          increaseColor: DI<ColorConst>().dark_greenColor,
                          decreaseColor: DI<ColorConst>().redColor,
                        ),
                      ),
                SizedBox(height: 16),
                // OPEN, HIGH, LOW, PREVIOUS CLOSE
                _homeCtrl.isLoading.value
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statItem("OPEN", open.toStringAsFixed(2), DI<ColorConst>().blackColor),
                          _statItem("HIGH", high.toStringAsFixed(2), DI<ColorConst>().dark_greenColor),
                          _statItem("LOW", low.toStringAsFixed(2), DI<ColorConst>().redColor),
                          _statItem("PREVIOUS CLOSE", prevClose.toStringAsFixed(2), DI<ColorConst>().blackColor),
                        ],
                      ),
                SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _statItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 11, FontWeight.w400)),
        SizedBox(height: 4),
        Text(value, style: DI<CommonWidget>().myTextStyle(color, 13, FontWeight.w600)),
      ],
    );
  }

  void showOptionChainDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.info_outline, color: Colors.orange, size: 30),
                  ),
                  SizedBox(height: 16),
                  Text("Option Chain Access", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 18, FontWeight.w600)),
                  SizedBox(height: 12),
                  Text(
                    "You cannot access this feature. Please contact the company to enable Option Chain access.",
                    textAlign: TextAlign.center,
                    style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 14, FontWeight.w400),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 120,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DI<ColorConst>().redColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: Get.back,
                      child: Text("OK", style: TextStyle(color: DI<ColorConst>().whiteColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: InkWell(onTap: Get.back, child: Icon(Icons.close, color: DI<ColorConst>().darkGryColor)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}

/// Candlestick chart with volume bars below and optional CPR levels.
class CandlestickWithVolume extends StatelessWidget {
  final List<CandleData> candles;
  final List<CprLevel> cprLevels;
  final double chartHeight;
  final double volumeHeight;
  final Color increaseColor;
  final Color decreaseColor;

  const CandlestickWithVolume({
    super.key,
    required this.candles,
    this.cprLevels = const <CprLevel>[],
    required this.chartHeight,
    required this.volumeHeight,
    required this.increaseColor,
    required this.decreaseColor,
  });

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) return SizedBox(height: chartHeight + volumeHeight);
    final minP = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final maxP = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final pad = (maxP - minP) * 0.05;
    final priceMin = minP - pad;
    final priceMax = maxP + pad;
    final steps = 5;
    final priceLabels = List.generate(steps + 1, (i) => priceMax - (priceMax - priceMin) * i / steps);

    return Column(
      children: [
        SizedBox(
          height: chartHeight,
          child: Stack(
            children: [
              CustomPaint(
                painter: CandlestickPainter(
                  candles: candles,
                  cprLevels: cprLevels,
                  increaseColor: increaseColor,
                  decreaseColor: decreaseColor,
                ),
                size: Size.infinite,
              ),
              Positioned(
                right: 4,
                top: 20,
                bottom: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: priceLabels.map((v) => Text(
                    v.toStringAsFixed(0),
                    style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: volumeHeight,
          child: CustomPaint(
            painter: VolumeBarPainter(
              candles: candles,
              increaseColor: increaseColor,
              decreaseColor: decreaseColor,
            ),
            size: Size.infinite,
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(candles.first.timeLabel, style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10)),
              Text(candles[candles.length ~/ 2].timeLabel, style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10)),
              Text(candles.last.timeLabel, style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}

class CandlestickPainter extends CustomPainter {
  final List<CandleData> candles;
  final List<CprLevel> cprLevels;
  final Color increaseColor;
  final Color decreaseColor;

  CandlestickPainter({
    required this.candles,
    this.cprLevels = const <CprLevel>[],
    required this.increaseColor,
    required this.decreaseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;
    final minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final pad = (maxPrice - minPrice) * 0.05;
    final priceMin = minPrice - pad;
    final priceMax = maxPrice + pad;
    final priceRange = priceMax - priceMin;

    final padding = 24.0;
    final chartW = size.width - padding * 2;
    final chartH = size.height - padding * 2;
    final n = candles.length;
    final candleW = (chartW / n).clamp(4.0, 24.0);
    final gap = (chartW - candleW * n) / (n + 1);

    // CPR horizontal lines (dashed) – draw behind candles
    for (final level in cprLevels) {
      if (level.price < priceMin || level.price > priceMax) continue;
      final y = padding + chartH * (1 - (level.price - priceMin) / priceRange);
      final dashWidth = 6.0;
      final dashGap = 4.0;
      double x = padding;
      final linePaint = Paint()..color = level.color..strokeWidth = 1.5..style = PaintingStyle.stroke;
      while (x < padding + chartW) {
        canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), linePaint);
        x += dashWidth + dashGap;
      }
    }

    for (int i = 0; i < n; i++) {
      final c = candles[i];
      final x = padding + gap + (gap + candleW) * i + candleW / 2;
      final color = c.isUp ? increaseColor : decreaseColor;

      // Wick: high to low
      final yHigh = padding + chartH * (1 - (c.high - priceMin) / priceRange);
      final yLow = padding + chartH * (1 - (c.low - priceMin) / priceRange);
      canvas.drawLine(Offset(x, yHigh), Offset(x, yLow), Paint()..color = color..strokeWidth = 1.5);

      // Body: open to close
      final yOpen = padding + chartH * (1 - (c.open - priceMin) / priceRange);
      final yClose = padding + chartH * (1 - (c.close - priceMin) / priceRange);
      final top = yOpen < yClose ? yOpen : yClose;
      final bodyH = (yOpen - yClose).abs().clamp(2.0, chartH);
      final left = x - candleW / 2;
      final rect = RRect.fromRectAndRadius(Rect.fromLTWH(left, top, candleW, bodyH), Radius.circular(1));
      canvas.drawRRect(rect, Paint()..color = color);
      canvas.drawRRect(rect, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class VolumeBarPainter extends CustomPainter {
  final List<CandleData> candles;
  final Color increaseColor;
  final Color decreaseColor;

  VolumeBarPainter({
    required this.candles,
    required this.increaseColor,
    required this.decreaseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;
    final maxVol = candles.map((c) => c.volume).reduce((a, b) => a > b ? a : b);
    if (maxVol <= 0) return;

    final padding = 24.0;
    final chartW = size.width - padding * 2;
    final chartH = size.height - padding * 2;
    final n = candles.length;
    final barW = (chartW / n).clamp(2.0, 16.0);
    final gap = (chartW - barW * n) / (n + 1);

    for (int i = 0; i < n; i++) {
      final c = candles[i];
      final color = c.isUp ? increaseColor : decreaseColor;
      final h = chartH * (c.volume / maxVol);
      final x = padding + gap + (gap + barW) * i;
      final y = padding + chartH - h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, barW, h), Radius.circular(2)),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
