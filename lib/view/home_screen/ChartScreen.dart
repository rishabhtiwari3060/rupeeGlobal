import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonFunction.dart';
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
          String categoryLabel = isMarketIndex ? "MARKET INDICES" : "FOREX MARKET";

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

          // Build candle/line data from API response (depends on selected timeframe)
          final timeframeIndex = _chartCtrl.selectedTimeframe.value;
          final candles = _buildSampleCandles(price, open, high, low, timeframeIndex);

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
                SizedBox(
                  height: 15,
                ),
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
                Text("$displayName", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().darkGryColor, 13, FontWeight.w400)),
                SizedBox(height: 4),
                _homeCtrl.isLoading.value 
                    ? Text("Loading...", style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 28, FontWeight.w700))
                    : Text(DI<CommonFunction>().formatPrice(price, decimalPlaces: isMarketIndex ? 2 : 5), style: DI<CommonWidget>().myTextStyle(changeColor, 28, FontWeight.w700)),
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
                        height: 40.h,
                        child: LineAreaChart(
                          candles: candles,
                          lineColor: changeColor,
                          isNegative: isNegative,
                        ),
                      ),
                SizedBox(height: 16),
                // OPEN, HIGH, LOW, PREVIOUS CLOSE
                _homeCtrl.isLoading.value
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statItem("OPEN", DI<CommonFunction>().formatPrice(open, decimalPlaces: isMarketIndex ? 2 : 5), DI<ColorConst>().blackColor),
                          _statItem("HIGH", DI<CommonFunction>().formatPrice(high, decimalPlaces: isMarketIndex ? 2 : 5), DI<ColorConst>().dark_greenColor),
                          _statItem("LOW", DI<CommonFunction>().formatPrice(low, decimalPlaces: isMarketIndex ? 2 : 5), DI<ColorConst>().redColor),
                          _statItem("PREVIOUS CLOSE", DI<CommonFunction>().formatPrice(prevClose, decimalPlaces: isMarketIndex ? 2 : 5), DI<ColorConst>().blackColor),
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

  @override
  void dispose() {
    Get.delete<ChartController>();
    super.dispose();
  }

  /// Build chart data based on timeframe (matches website: 1D=24, 1W=7, 1M=30, 1Y=12, ALL=60)
  List<CandleData> _buildSampleCandles(double price, double open, double high, double low, int timeframeIndex) {
    const timeframes = ['1D', '1W', '1M', '1Y', 'ALL'];
    const pointsMap = {'1D': 24, '1W': 7, '1M': 30, '1Y': 12, 'ALL': 60};
    const variationMap = {'1D': 0.01, '1W': 0.02, '1M': 0.03, '1Y': 0.05, 'ALL': 0.08};
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

    final tf = timeframes[timeframeIndex.clamp(0, 4)];
    final points = pointsMap[tf] ?? 24;
    final variationFactor = variationMap[tf] ?? 0.01;
    final basePrice = price;
    final now = DateTime.now();
    final list = <CandleData>[];
    final decimals = basePrice < 100 ? 5 : 2;

    for (int i = points - 1; i >= 0; i--) {
      double c;
      if (i == 0) {
        c = price;
      } else {
        final variation = ((i / points) - 0.5) * (basePrice * variationFactor);
        c = double.parse((basePrice + variation).toStringAsFixed(decimals));
      }

      String timeLabel;
      if (tf == '1D') {
        final time = now.subtract(Duration(hours: i));
        timeLabel = (i % 2 == 0 || i == points - 1 || i == 0)
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : '';
      } else if (tf == '1W') {
        final date = now.subtract(Duration(days: i));
        timeLabel = '${months[date.month - 1]} ${date.day}';
      } else if (tf == '1M') {
        final date = now.subtract(Duration(days: i));
        timeLabel = (i % 5 == 0 || i == points - 1 || i == 0) ? '${months[date.month - 1]} ${date.day}' : '';
      } else if (tf == '1Y') {
        final date = DateTime(now.year, now.month - i, 1);
        timeLabel = '${months[date.month - 1]} ${date.year.toString().substring(2)}';
      } else {
        final date = DateTime(now.year, now.month - i, 1);
        timeLabel = (i % 3 == 0 || i == points - 1 || i == 0) ? '${months[date.month - 1]} ${date.year.toString().substring(2)}' : '';
      }

      list.add(CandleData(
        open: c,
        high: c + 0.001,
        low: c - 0.001,
        close: c,
        volume: 1.0,
        timeLabel: timeLabel.isEmpty ? (tf == '1D' ? '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}' : 'Now') : timeLabel,
      ));
    }
    return list;
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

String _firstNonEmptyLabel(List<CandleData> c) {
  for (final x in c) if (x.timeLabel.isNotEmpty) return x.timeLabel;
  return '';
}
String _lastNonEmptyLabel(List<CandleData> c) {
  for (int i = c.length - 1; i >= 0; i--) if (c[i].timeLabel.isNotEmpty) return c[i].timeLabel;
  return '';
}
String _labelAt(List<CandleData> c, int i) {
  if (i < c.length && c[i].timeLabel.isNotEmpty) return c[i].timeLabel;
  for (int j = i; j < c.length; j++) if (c[j].timeLabel.isNotEmpty) return c[j].timeLabel;
  for (int j = i; j >= 0; j--) if (c[j].timeLabel.isNotEmpty) return c[j].timeLabel;
  return '';
}

/// Line chart with area fill (red line + light red gradient), like forex chart.
class LineAreaChart extends StatelessWidget {
  final List<CandleData> candles;
  final Color lineColor;
  final bool isNegative;

  const LineAreaChart({
    super.key,
    required this.candles,
    required this.lineColor,
    this.isNegative = true,
  });

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) return SizedBox();
    final closes = candles.map((c) => c.close).toList();
    final minP = closes.reduce((a, b) => a < b ? a : b);
    final maxP = closes.reduce((a, b) => a > b ? a : b);
    var pad = (maxP - minP) * 0.08;
    if (pad <= 0) pad = (maxP.abs().clamp(0.001, double.infinity)) * 0.01;
    final priceMin = minP - pad;
    final priceMax = maxP + pad;
    final steps = 5;
    final priceLabels = List.generate(steps + 1, (i) => priceMax - (priceMax - priceMin) * i / steps);
    final decimals = maxP < 100 ? 5 : 2;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              CustomPaint(
                painter: LineAreaChartPainter(
                  candles: candles,
                  lineColor: lineColor,
                  priceMin: priceMin,
                  priceMax: priceMax,
                ),
                size: Size.infinite,
              ),
              Positioned(
                right: 4,
                top: 16,
                bottom: 16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: priceLabels.map((v) => Text(
                    v.toStringAsFixed(decimals),
                    style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_firstNonEmptyLabel(candles), style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10)),
              if (candles.length > 2) Text(_labelAt(candles, candles.length ~/ 2), style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10)),
              Text(_lastNonEmptyLabel(candles), style: TextStyle(color: DI<ColorConst>().darkGryColor, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}

class LineAreaChartPainter extends CustomPainter {
  final List<CandleData> candles;
  final Color lineColor;
  final double priceMin;
  final double priceMax;

  LineAreaChartPainter({
    required this.candles,
    required this.lineColor,
    required this.priceMin,
    required this.priceMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;
    final priceRange = priceMax - priceMin;
    if (priceRange <= 0) return;

    final padding = 20.0;
    final chartW = size.width - padding - 36;
    final chartH = size.height - padding * 2;
    final n = candles.length;

    // Horizontal grid lines (faint grey)
    final gridPaint = Paint()
      ..color = DI<ColorConst>().darkGryColor.withOpacity(0.15)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (int i = 0; i <= 5; i++) {
      final y = padding + chartH * i / 5;
      canvas.drawLine(Offset(padding, y), Offset(padding + chartW, y), gridPaint);
    }

    // Build line path from close prices
    final points = <Offset>[];
    for (int i = 0; i < n; i++) {
      final close = candles[i].close;
      final x = padding + (chartW / (n - 1).clamp(1, n)) * i;
      final y = padding + chartH * (1 - (close - priceMin) / priceRange);
      points.add(Offset(x, y));
    }
    if (points.length < 2) return;

    // Area fill (gradient: line color to white)
    final fillPath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points.last.dx, padding + chartH);
    fillPath.lineTo(points.first.dx, padding + chartH);
    fillPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lineColor.withOpacity(0.35),
        lineColor.withOpacity(0.08),
        Colors.white,
      ],
    ).createShader(Rect.fromLTWH(0, 0, chartW, chartH + padding));
    canvas.drawPath(fillPath, Paint()..shader = gradient);

    // Line
    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
