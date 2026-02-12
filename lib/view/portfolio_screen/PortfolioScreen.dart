import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonFunction.dart';
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
    super.initState();

    Future.delayed(Duration.zero, () {
      homeTabController.getPortfolio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => homeTabController.isLoading.value
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),

                    /// ─── Portfolio Summary ─────────────────
                    _sectionHeader(Icons.pie_chart_outline_rounded,
                        DI<StringConst>().portfolio_summary_text),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Total Invested",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.portfolio.totalInvested)}",
                              DI<ColorConst>().blackColor,
                              Icons.account_balance_wallet_outlined),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "Current Value",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.portfolio.totalValue)}",
                              DI<ColorConst>().blackColor,
                              Icons.trending_up_rounded),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Total P&L",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.portfolio.totalPnl)}",
                              DI<ColorConst>().dark_greenColor,
                              Icons.show_chart_rounded),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "P&L %",
                              "${_formatPercent(homeTabController.portfolioModel.value?.data.portfolio.pnlPercent)}%",
                              DI<ColorConst>().dark_greenColor,
                              Icons.percent_rounded),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    /// ─── Profit & Loss ──────────────────────
                    _sectionHeader(
                        Icons.analytics_outlined, "Profit & Loss"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Today",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.profitLoss.today)}",
                              DI<ColorConst>().dark_greenColor,
                              null),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "This Week",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.profitLoss.week)}",
                              DI<ColorConst>().dark_greenColor,
                              null),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "This Month",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.profitLoss.month)}",
                              DI<ColorConst>().dark_greenColor,
                              null),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "This Year",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.profitLoss.year)}",
                              DI<ColorConst>().dark_greenColor,
                              null),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    /// ─── Fund Statistics ────────────────────
                    _sectionHeader(
                        Icons.account_balance_outlined, "Fund Statistics"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Current Balance",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.funds.currentBalance, decimalPlaces: 0)}",
                              _fundAmountColor(homeTabController.portfolioModel.value?.data.funds.currentBalance ?? 0),
                              null),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "Total Added",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.funds.totalAdded, decimalPlaces: 0)}",
                              DI<ColorConst>().dark_greenColor,
                              null),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Total Withdrawn",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.funds.totalWithdrawn, decimalPlaces: 0)}",
                              DI<ColorConst>().redColor,
                              null),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "Net Deposit",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.funds.netDeposit, decimalPlaces: 0)}",
                              _fundAmountColor(homeTabController.portfolioModel.value?.data.funds.netDeposit ?? 0),
                              null),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    /// ─── Fund Flow ──────────────────────────
                    _sectionHeader(
                        Icons.swap_vert_rounded, "Fund Flow"),
                    SizedBox(height: 10),
                    _buildFundFlowTable(),

                    SizedBox(height: 24),

                    /// ─── Trade Statistics ───────────────────
                    _sectionHeader(
                        Icons.bar_chart_rounded, "Trade Statistics"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Total Positions",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.trades.total)}",
                              DI<ColorConst>().blackColor,
                              Icons.list_alt_rounded),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "Profitable",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.trades.winning)}",
                              DI<ColorConst>().dark_greenColor,
                              Icons.thumb_up_alt_outlined),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                              "Loss Making",
                              "₹${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.trades.losing)}",
                              DI<ColorConst>().redColor,
                              Icons.thumb_down_alt_outlined),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                              "Success Rate",
                              "${homeTabController.portfolioModel.value?.data.trades.winRate}%",
                              DI<ColorConst>().blackColor,
                              Icons.emoji_events_outlined),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    /// ─── Charges & Fees ─────────────────────
                    _sectionHeader(
                        Icons.receipt_long_outlined, "Charges & Fees"),
                    SizedBox(height: 10),
                    _buildChargesList(),

                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }

  /// ─── Section Header with Icon ────────────────────
  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: DI<ColorConst>().secondColorPrimary, size: 22),
        SizedBox(width: 8),
        Text(
          title,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20.sp, FontWeight.w600),
        ),
      ],
    );
  }

  /// ─── Stat Card with optional icon ────────────────
  Widget _statCard(String title, String amount, Color valueColor, IconData? icon) {
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
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: DI<ColorConst>().darkGryColor, size: 16),
                SizedBox(width: 5),
              ],
              Expanded(
                child: Text(
                  title,
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            amount,
            style: DI<CommonWidget>()
                .myTextStyle(valueColor, 18.sp, FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// ─── Fund Flow Table ─────────────────────────────
  Widget _buildFundFlowTable() {
    final data = homeTabController.portfolioModel.value?.data;
    if (data == null) return SizedBox();

    return Container(
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
          /// Header Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: DI<ColorConst>().secondColorPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _tableHeaderText("Period")),
                Expanded(flex: 2, child: _tableHeaderText("Added")),
                Expanded(flex: 2, child: _tableHeaderText("Withdrawn")),
                Expanded(flex: 2, child: _tableHeaderText("Net")),
              ],
            ),
          ),
          _fundFlowRow(
            "Today",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.today.added)}",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.today.withdrawn)}",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.today.added - data.funds.today.withdrawn)}",
          ),
          Divider(height: 0, thickness: 0.5, color: DI<ColorConst>().dividerColor.withOpacity(0.3), indent: 14, endIndent: 14),
          _fundFlowRow(
            "This Month",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.month.added)}",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.month.withdrawn)}",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.month.added - data.funds.month.withdrawn)}",
          ),
          Divider(height: 0, thickness: 0.5, color: DI<ColorConst>().dividerColor.withOpacity(0.3), indent: 14, endIndent: 14),
          _fundFlowRow(
            "This Year",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.year.added)}",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.year.withdrawn)}",
            "₹ ${DI<CommonFunction>().formatPrice(data.funds.year.added - data.funds.year.withdrawn)}",
          ),
        ],
      ),
    );
  }

  Widget _tableHeaderText(String text) {
    return Text(
      text,
      style: DI<CommonWidget>().myTextStyle(
          DI<ColorConst>().secondColorPrimary, 14.sp, FontWeight.w600),
    );
  }

  Widget _fundFlowRow(String period, String added, String withdrawn, String net) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(period,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor, 14.sp, FontWeight.w400)),
          ),
          Expanded(
            flex: 2,
            child: Text(added,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().dark_greenColor, 14.sp, FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Text(withdrawn,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().redColor, 14.sp, FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Text(net,
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().dark_greenColor, 14.sp, FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  /// ─── Charges List ────────────────────────────────
  Widget _buildChargesList() {
    final charges = homeTabController.portfolioModel.value?.data.charges;
    if (charges == null || charges.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: DI<ColorConst>().cardBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: DI<ColorConst>().dividerColor.withOpacity(0.4),
            width: 0.8,
          ),
        ),
        child: Center(
          child: Text(
            "No charges yet",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 16.sp, FontWeight.w400),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(charges.length, (index) {
          final item = charges[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${item.chargeType}",
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().blackColor, 16.sp, FontWeight.w600),
                      ),
                    ),
                    Text(
                      "₹ ${DI<CommonFunction>().formatPrice(item.amount)}",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().blackColor, 16.sp, FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 14, color: DI<ColorConst>().darkGryColor),
                    SizedBox(width: 4),
                    Text(
                      "${DI<CommonFunction>().formatDate(item.date)}",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().secondColorPrimary,
                          14.sp,
                          FontWeight.w400),
                    ),
                  ],
                ),
                if (item.note != null && item.note.toString().isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    "${item.note}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w400),
                  ),
                ],
              ],
            ),
          );
        }),

        /// Total Charges
        Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: DI<ColorConst>().secondColorPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Charges",
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor, 16.sp, FontWeight.w600),
              ),
              Text(
                "₹ ${DI<CommonFunction>().formatPrice(homeTabController.portfolioModel.value?.data.totalCharges ?? 0)}",
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor, 17.sp, FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Color for fund amount: green if positive, red if negative, black if zero
  Color _fundAmountColor(num value) {
    if (value > 0) return DI<ColorConst>().dark_greenColor;
    if (value < 0) return DI<ColorConst>().redColor;
    return DI<ColorConst>().blackColor;
  }

  /// Format long percentages
  String _formatPercent(dynamic value) {
    if (value == null) return "0.00";
    double v = double.tryParse(value.toString()) ?? 0.0;
    return v.toStringAsFixed(2);
  }
}
