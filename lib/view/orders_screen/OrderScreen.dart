import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:rupeeglobal/model/PositionModel.dart';
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
  HomeTabController homeTabController = Get.find<HomeTabController>();

  var selectType = 0.obs;
  var selectPositionType = 0.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // Load holdings for Holdings tab
      homeTabController.getHoldingList("1");
      // Load positions for Positions tab with default filters
      homeTabController.getPositionList("1", type: "Regular", status: "CF");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              /// ─── Top Tabs: Positions / Holdings ──────
              _buildTopTabs(),
              SizedBox(height: 16),

              if (selectType.value == 0)
                homeTabController.isLoading.value
                    ? SizedBox()
                    : _positionsSection(),

              if (selectType.value == 1)
                homeTabController.isLoading.value
                    ? SizedBox()
                    : _holdingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// ─── Top Tab Selector (Positions / Holdings) ─────
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
          _tabItem(DI<StringConst>().positions_text, 0, selectType),
          SizedBox(width: 4),
          _tabItem(DI<StringConst>().holdings_text, 1, selectType),
        ],
      ),
    );
  }

  /// ─── Generic Tab Item ────────────────────────────
  Widget _tabItem(String label, int index, RxInt selected) {
    final isSelected = selected.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => selected.value = index,
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
                14.sp,
                FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ─── Positions Section ───────────────────────────
  Widget _positionsSection() {
    // Count positions by type
    final regularCount = homeTabController.positionList
        .where((p) => p.type == "Regular")
        .length;
    final mtfCount = homeTabController.positionList
        .where((p) => p.type == "MTF")
        .length;
    final strategyCount = homeTabController.positionList
        .where((p) => p.type == "Strategy")
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Sub-tabs: Regular / MTF / Strategy
        _buildSubTabs(regularCount, mtfCount, strategyCount),
        SizedBox(height: 14),

        _positionList(),
      ],
    );
  }

  /// ─── Sub-Tab Selector ────────────────────────────
  Widget _buildSubTabs(int regularCount, int mtfCount, int strategyCount) {
    return Row(
      children: [
        _pillTab("${DI<StringConst>().regular_text} ($regularCount)", 0, selectPositionType, "Regular"),
        SizedBox(width: 8),
        _pillTab("${DI<StringConst>().mtf_text} ($mtfCount)", 1, selectPositionType, "MTF"),
        SizedBox(width: 8),
        _pillTab("${DI<StringConst>().strategy_text} ($strategyCount)", 2, selectPositionType, "Strategy"),
      ],
    );
  }

  /// ─── Pill-style Sub Tab ──────────────────────────
  Widget _pillTab(String label, int index, RxInt selected, String type) {
    final isSelected = selected.value == index;
    return InkWell(
      onTap: () {
        selected.value = index;
        homeTabController.changePositionType(type);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? DI<ColorConst>().secondColorPrimary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? DI<ColorConst>().secondColorPrimary
                : DI<ColorConst>().dividerColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: DI<CommonWidget>().myTextStyle(
            isSelected
                ? DI<ColorConst>().secondColorPrimary
                : DI<ColorConst>().darkGryColor,
            11.sp,
            FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// ─── Position List with P&L Summary ──────────────
  Widget _positionList() {
    final totalPnl = homeTabController.positionModel.value?.data.totalPnl ?? 0;
    final positions = homeTabController.positionList;
    
    // Separate CF and Closed positions
    final cfPositions = positions.where((p) => p.status == "CF").toList();
    final closedPositions = positions.where((p) => p.status == "Closed").toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// P&L summary cards
        Row(
          children: [
            Expanded(child: _pnlCard("Day's P&L", "₹ ${totalPnl.toStringAsFixed(2)}", Icons.today_rounded)),
            SizedBox(width: 10),
            Expanded(child: _pnlCard("Overall P&L", "₹ ${totalPnl.toStringAsFixed(2)}", Icons.assessment_outlined)),
          ],
        ),
        SizedBox(height: 16),

        // CF Positions
        if (cfPositions.isNotEmpty) ...[
          Text(
            "CF (${cfPositions.length})",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w500),
          ),
          SizedBox(height: 6),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cfPositions.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _positionCard(cfPositions[index]);
            },
          ),
          SizedBox(height: 16),
        ],

        // Closed Positions
        if (closedPositions.isNotEmpty) ...[
          Text(
            "Closed (${closedPositions.length})",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w500),
          ),
          SizedBox(height: 6),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: closedPositions.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _positionCard(closedPositions[index]);
            },
          ),
        ],

        // Empty state
        if (positions.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: DI<ColorConst>().darkGryColor),
                  SizedBox(height: 12),
                  Text(
                    "No positions found",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// ─── P&L Summary Card ────────────────────────────
  Widget _pnlCard(String title, String value, IconData icon) {
    final isNegative = value.contains("-");
    final pnlColor = isNegative ? DI<ColorConst>().redColor : DI<ColorConst>().dark_greenColor;
    
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DI<ColorConst>().secondColorPrimary.withOpacity(0.08),
            DI<ColorConst>().cardBgColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: DI<ColorConst>().darkGryColor, size: 16),
              SizedBox(width: 5),
              Text(
                title,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: DI<CommonWidget>().myTextStyle(
                pnlColor, 17.sp, FontWeight.w700),
          ),
        ],
      ),
    );
  }

  /// ─── Single Position Card ────────────────────────
  Widget _positionCard(Position position) {
    final isNegative = position.pnl < 0;
    final pnlColor = isNegative ? DI<ColorConst>().redColor : DI<ColorConst>().dark_greenColor;
    final pnlText = isNegative 
        ? "₹ ${position.pnl.toStringAsFixed(2)}" 
        : "₹ ${position.pnl.toStringAsFixed(2)}";
    final pnlPercentText = isNegative 
        ? "(${position.pnlPercent.toStringAsFixed(2)}%)" 
        : "(${position.pnlPercent.toStringAsFixed(2)}%)";

    // Format expiry date
    String formattedExpiry = position.expiryDate;
    if (position.expiryDate.isNotEmpty) {
      try {
        final date = DateTime.parse(position.expiryDate);
        formattedExpiry = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        formattedExpiry = position.expiryDate;
      }
    }

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          /// Symbol & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  position.symbol,
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().blackColor, 14.sp, FontWeight.w600),
                ),
              ),
              Text(
                pnlText,
                style: DI<CommonWidget>().myTextStyle(
                    pnlColor, 14.sp, FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 4),

          /// Date & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 13, color: DI<ColorConst>().darkGryColor),
                  SizedBox(width: 4),
                  Text(
                    "$formattedExpiry · Qty ${position.quantity}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 11.sp, FontWeight.w400),
                  ),
                ],
              ),
              Text(
                pnlPercentText,
                style: DI<CommonWidget>().myTextStyle(
                    pnlColor, 11.sp, FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            height: 0,
            thickness: 0.6,
            color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          ),
          SizedBox(height: 10),

          /// Buy / Sell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_downward_rounded,
                      size: 15, color: DI<ColorConst>().secondColorPrimary),
                  SizedBox(width: 4),
                  Text(
                    "Buy ₹ ${position.buyPrice.toStringAsFixed(2)}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w400),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.arrow_upward_rounded,
                      size: 15, color: DI<ColorConst>().dark_greenColor),
                  SizedBox(width: 4),
                  Text(
                    "Sell ₹ ${position.sellPrice.toStringAsFixed(2)}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 12.sp, FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// ─── Holdings Section ────────────────────────────
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _holdingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Summary Cards
        Row(
          children: [
            Expanded(
              child: _holdingSummaryCard(
                "Total Invested",
                "₹${homeTabController.holdingModel.value?.data.summary.totalInvested ?? 0}",
                DI<ColorConst>().blackColor,
                Icons.account_balance_wallet_outlined,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _holdingSummaryCard(
                "Total Value",
                "₹${homeTabController.holdingModel.value?.data.summary.totalValue ?? 0}",
                DI<ColorConst>().blackColor,
                Icons.trending_up_rounded,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _holdingSummaryCard(
                "Margin",
                "₹${homeTabController.holdingModel.value?.data.summary.margin ?? 0}",
                DI<ColorConst>().dark_greenColor,
                Icons.savings_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        /// Holdings List
        homeTabController.holdingList.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: DI<ColorConst>().darkGryColor),
                      SizedBox(height: 12),
                      Text(
                        "No holdings found",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: homeTabController.holdingList.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = homeTabController.holdingList[index];
                  final isNegative = item.pnl.toString().contains("-");
                  return _holdingCard(item, isNegative);
                },
              ),
      ],
    );
  }

  /// ─── Holding Summary Card ────────────────────────
  Widget _holdingSummaryCard(
      String title, String amount, Color valueColor, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DI<ColorConst>().darkGryColor, size: 18),
          SizedBox(height: 6),
          Text(
            title,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 10.sp, FontWeight.w400),
          ),
          SizedBox(height: 4),
          Text(
            amount,
            style: DI<CommonWidget>()
                .myTextStyle(valueColor, 13.sp, FontWeight.w700),
          ),
        ],
      ),
    );
  }

  /// ─── Single Holding Card ─────────────────────────
  Widget _holdingCard(dynamic item, bool isNegative) {
    final pnlColor =
        isNegative ? DI<ColorConst>().redColor : DI<ColorConst>().dark_greenColor;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Symbol & Company
          Text(
            item.symbol.toString(),
            style: DI<CommonWidget>()
                .myTextStyle(DI<ColorConst>().blackColor, 14.sp, FontWeight.w600),
          ),
          SizedBox(height: 2),
          Text(
            item.companyName.toString(),
            style: DI<CommonWidget>()
                .myTextStyle(DI<ColorConst>().darkGryColor, 11.sp, FontWeight.w400),
          ),
          SizedBox(height: 12),

          /// Qty / Avg Price / LTP / Value
          Row(
            children: [
              _holdingInfoChip("Qty", "${item.quantity}"),
              SizedBox(width: 8),
              _holdingInfoChip("Avg", "₹${item.avgPrice}"),
              SizedBox(width: 8),
              _holdingInfoChip("LTP", "₹${item.ltp}"),
              SizedBox(width: 8),
              _holdingInfoChip("Value", "₹${item.value}"),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            height: 0,
            thickness: 0.6,
            color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          ),
          SizedBox(height: 10),

          /// P&L row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isNegative
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    color: pnlColor,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "P&L: ₹${item.pnl}",
                    style: DI<CommonWidget>()
                        .myTextStyle(pnlColor, 13.sp, FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pnlColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${item.pnlPercent.toStringAsFixed(2)}%",
                  style: DI<CommonWidget>()
                      .myTextStyle(pnlColor, 11.sp, FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ─── Small info chip for holdings ────────────────
  Widget _holdingInfoChip(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 10.sp, FontWeight.w400),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 12.sp, FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
