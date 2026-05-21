import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/home_tab/HomeTabController.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

class FundsScreen extends StatefulWidget {
  const FundsScreen({super.key});

  @override
  State<FundsScreen> createState() => _FundsScreenState();
}

class _FundsScreenState extends State<FundsScreen> {
  HomeTabController homeTabController = Get.find<HomeTabController>();

  var selectType = 0.obs;

  late TextEditingController amountCtrl;
  late TextEditingController noteCtrl;
  late TextEditingController amountWithdrawCtrl;
  late TextEditingController upiIdWithdrawCtrl;
  late TextEditingController upiNameWithdrawCtrl;
  late TextEditingController noteWithdrawCtrl;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      homeTabController.getFundList("1");
    });

    amountCtrl = TextEditingController();
    noteCtrl = TextEditingController();
    amountWithdrawCtrl = TextEditingController();
    upiIdWithdrawCtrl = TextEditingController();
    upiNameWithdrawCtrl = TextEditingController();
    noteWithdrawCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              /// Section header
              _sectionHeader(Icons.account_balance_wallet_outlined,
                  DI<StringConst>().funds_balance_text),
              SizedBox(height: 14),

              /// Tab selector
              _buildTabs(),
              SizedBox(height: 16),

              if (selectType.value == 0)
                homeTabController.isLoading.value
                    ? SizedBox()
                    : _fundColumn(),

              if (selectType.value == 1) _addFundColumn(),
              if (selectType.value == 2) _withdrawFundColumn(),
              if (selectType.value == 3)
                homeTabController.isPaymentQrLoading.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: DI<ColorConst>().secondColorPrimary)),
                      )
                    : _payAmountColumn(),
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
              .myTextStyle(DI<ColorConst>().blackColor, 22.sp, FontWeight.w600),
        ),
      ],
    );
  }

  /// ─── Tabs ────────────────────────────────────────
  Widget _buildTabs() {
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
          _tabItem(DI<StringConst>().funds_text, 0),
          SizedBox(width: 3),
          _tabItem(DI<StringConst>().add_fund_text, 1),
          SizedBox(width: 3),
          _tabItem(DI<StringConst>().withdraw_funds_text, 2),
          SizedBox(width: 3),
          _tabItem(DI<StringConst>().pay_amount_text, 3),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final isSelected = selectType.value == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          selectType.value = index;
          if (index == 3) homeTabController.getPaymentQrList();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 9),
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
                isSelected ? Colors.white : DI<ColorConst>().blackColor,
                13.sp,
                FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// ─── Funds Tab ───────────────────────────────────
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _fundColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Summary row
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                "Available Balance",
                "₹${DI<CommonFunction>().formatPrice(homeTabController.fundsModel.value?.data.balance)}",
                DI<ColorConst>().dark_greenColor,
                Icons.account_balance_outlined,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                "Margin",
                "${homeTabController.fundsModel.value?.data.margin}X",
                DI<ColorConst>().blackColor,
                Icons.speed_outlined,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                "Total Funds",
                "₹${DI<CommonFunction>().formatPrice(double.parse(homeTabController.fundsModel.value?.data.balance??"0.0") * double.parse(homeTabController.fundsModel.value?.data.margin??"0.0"))}",
                DI<ColorConst>().blackColor,
                Icons.savings_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        /// Transaction History header
        Row(
          children: [
            Icon(Icons.history_rounded,
                color: DI<ColorConst>().secondColorPrimary, size: 20),
            SizedBox(width: 6),
            Text(
              DI<StringConst>().transaction_history_text,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 13.sp, FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 10),

        /// Transaction list
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homeTabController.fundsList.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = homeTabController.fundsList[index];
            return _transactionCard(item, index);
          },
        ),
      ],
    );
  }

  /// ─── Summary Card ────────────────────────────────
  Widget _summaryCard(
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
                DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
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

  /// ─── Transaction Card ────────────────────────────
  Widget _transactionCard(dynamic item, int index) {
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
          /// Date + Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: DI<ColorConst>().darkGryColor),
                  SizedBox(width: 4),
                  Text(
                    "${DI<CommonFunction>().formatDate(item.createdAt)}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: DI<ColorConst>().dark_greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${item.transactionType}",
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().dark_greenColor, 13.sp, FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          /// Amount + Position
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "₹ ${DI<CommonFunction>().formatPrice(item.amount)}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().blackColor, 13.sp, FontWeight.w600),
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
  /// ─── Add Fund Tab ────────────────────────────────
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _addFundColumn() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DI<StringConst>().request_add_fund_text,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 13.sp, FontWeight.w600),
          ),
          SizedBox(height: 20),

          _fieldLabel(DI<StringConst>().amount_text),
          DI<CommonWidget>().myTextFormField(
            controller: amountCtrl,
            textInputType: TextInputType.number,
            "",
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 14),

          _fieldLabel(DI<StringConst>().notes_text),
          DI<CommonWidget>().myTextFormField(
            controller: noteCtrl,
            textInputType: TextInputType.text,
            "",
            minLine: 4,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 24),

          DI<CommonWidget>().myButton(
            DI<StringConst>().submit_fund_request_text,
            () {
              if (validationAddFund()) {
                homeTabController
                    .addFund(amountCtrl.text.trim())
                    .then((value) {
                  if (value) {
                    amountCtrl.clear();
                    noteCtrl.clear();
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _withdrawFundColumn() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DI<ColorConst>().cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DI<ColorConst>().dividerColor.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DI<StringConst>().request_withdraw_fund_text,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor, 13.sp, FontWeight.w600),
          ),
          SizedBox(height: 10),

          /// Available Balance badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: DI<ColorConst>().dark_greenColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${DI<StringConst>().available_balance_text} ₹${DI<CommonFunction>().formatPrice(homeTabController.fundsModel.value?.data.balance)}",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().dark_greenColor, 13.sp, FontWeight.w600),
            ),
          ),
          SizedBox(height: 16),

          _fieldLabel(DI<StringConst>().amount_text),
          DI<CommonWidget>().myTextFormField(
            controller: amountWithdrawCtrl,
            textInputType: TextInputType.number,
            "",
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 14),

          _fieldLabel(DI<StringConst>().upi_id_text),
          DI<CommonWidget>().myTextFormField(
            controller: upiIdWithdrawCtrl,
            textInputType: TextInputType.text,
            "",
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 14),

          _fieldLabel(DI<StringConst>().upi_name_text),
          DI<CommonWidget>().myTextFormField(
            controller: upiNameWithdrawCtrl,
            textInputType: TextInputType.text,
            "",
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 14),

          _fieldLabel(DI<StringConst>().notes_text),
          DI<CommonWidget>().myTextFormField(
            controller: noteWithdrawCtrl,
            textInputType: TextInputType.text,
            "",
            minLine: 4,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 24),

          DI<CommonWidget>().myButton(
            DI<StringConst>().submit_withdrawal_request_text,
            () {
              if (validationWithdrawFund()) {
                homeTabController
                    .withdrawFund(
                  amountWithdrawCtrl.text.trim(),
                  upiIdWithdrawCtrl.text.trim(),
                  upiNameWithdrawCtrl.text.trim(),
                  noteWithdrawCtrl.text.trim(),
                )
                    .then((value) {
                  if (value) {
                    amountWithdrawCtrl.clear();
                    noteWithdrawCtrl.clear();
                    upiIdWithdrawCtrl.clear();
                    upiNameWithdrawCtrl.clear();
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// ─── Pay Amount Tab ──────────────────────────────
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _payAmountColumn() {
    final list = homeTabController.paymentQrList;
    if (list.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.qr_code_2_outlined,
                  size: 48, color: DI<ColorConst>().darkGryColor),
              SizedBox(height: 12),
              Text(
                "No payment QR codes found",
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().darkGryColor, 14.sp, FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = list[index];
        final statusText = item.status.isNotEmpty
            ? (item.status[0].toUpperCase() + item.status.substring(1).toLowerCase())
            : "Assigned";
        final assignedDate =
            DI<CommonFunction>().formatDate(item.createdAt);
        final paymentDate = item.paymentDate == null ||
                item.paymentDate!.isEmpty
            ? "----"
            : DI<CommonFunction>().formatDate(item.paymentDate);

        return InkWell(
          onTap: () {
            Get.toNamed(
              DI<RouteHelper>().getPaymentQrDetailScreen(),
              arguments: {
                "id": item.id,
                "amount": item.amount,
                "status": item.status,
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
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
                /// Amount + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${DI<CommonFunction>().formatPrice(item.amount, decimalPlaces: 2)}",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().blackColor, 13.sp, FontWeight.w600),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: DI<ColorConst>()
                            .secondColorPrimary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().secondColorPrimary,
                            13.sp,
                            FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(
                  height: 0,
                  thickness: 0.6,
                  color: DI<ColorConst>().dividerColor.withOpacity(0.3),
                ),
                SizedBox(height: 10),

                /// Dates
                Row(
                  children: [
                    Expanded(
                      child: _dateInfo(
                          "Assigned Date", assignedDate, Icons.event_available),
                    ),
                    Expanded(
                      child: _dateInfo(
                          "Payment Date", paymentDate, Icons.event_note),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ─── Date info item ──────────────────────────────
  Widget _dateInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: DI<ColorConst>().darkGryColor),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
            ),
            Text(
              value,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor, 13.sp, FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  /// ─── Field Label ─────────────────────────────────
  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: DI<CommonWidget>().myTextStyle(
            DI<ColorConst>().darkGryColor, 13.sp, FontWeight.w400),
      ),
    );
  }

  /// ─── Validations ─────────────────────────────────
  bool validationAddFund() {
    if (amountCtrl.text.trim().isEmpty) {
      DI<CommonFunction>().showErrorSnackBar(
          "Please make sure all fields are filled correctly before continuing");
      return false;
    }
    return true;
  }

  bool validationWithdrawFund() {
    if (amountWithdrawCtrl.text.trim().isEmpty ||
        upiIdWithdrawCtrl.text.trim().isEmpty ||
        upiNameWithdrawCtrl.text.trim().isEmpty) {
      DI<CommonFunction>().showErrorSnackBar(
          "Please make sure all fields are filled correctly before continuing");
      return false;
    } else if (int.parse(amountWithdrawCtrl.text.trim()) >
        int.parse(
            homeTabController.fundsModel.value?.data.balance.toString() ??
                "0")) {
      DI<CommonFunction>()
          .showErrorSnackBar("Amount should be less than balance");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    amountWithdrawCtrl.dispose();
    upiIdWithdrawCtrl.dispose();
    upiNameWithdrawCtrl.dispose();
    noteWithdrawCtrl.dispose();
    super.dispose();
  }
}
