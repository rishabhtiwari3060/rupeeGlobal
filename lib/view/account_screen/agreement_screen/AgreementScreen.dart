import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/model/AgreementModel.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  AccountController accountController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      accountController.getAgreementsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: DI<ColorConst>().blackColor),
        ),
        title: Text(
          DI<StringConst>().agreements_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20.sp, FontWeight.w600),
        ),
      ),
      body: Obx(
        () => accountController.isAgreementLoading.value
            ? SizedBox()
            : accountController.agreementList.isEmpty
                ? _emptyState()
                : Column(
                    children: [
                      /// Summary Card
                      _buildSummaryCard(),

                      /// Agreement List
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          itemCount: accountController.agreementList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final agreement = accountController.agreementList[index];
                            return _agreementCard(agreement);
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  /// Summary Card showing pending/signed counts
  Widget _buildSummaryCard() {
    return Container(
      margin: EdgeInsets.all(14),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            DI<ColorConst>().secondColorPrimary,
            DI<ColorConst>().secondColorPrimary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              DI<StringConst>().pending_text,
              accountController.pendingAgreementsCount.toString(),
              Colors.orange,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _summaryItem(
              DI<StringConst>().signed_text,
              accountController.signedAgreementsCount.toString(),
              DI<ColorConst>().dark_greenColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto",
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
            ),
          ),
        ),
      ],
    );
  }

  /// Empty State
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined,
              size: 60, color: DI<ColorConst>().darkGryColor.withOpacity(0.4)),
          SizedBox(height: 12),
          Text(
            DI<StringConst>().no_agreements_found_text,
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor, 16.sp, FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Agreement Card
  Widget _agreementCard(Agreement agreement) {
    final isPending = agreement.isPending;
    final statusColor =
        isPending ? Colors.orange : DI<ColorConst>().dark_greenColor;
    final statusText = isPending
        ? DI<StringConst>().pending_text.toUpperCase()
        : DI<StringConst>().signed_text.toUpperCase();

    return InkWell(
      onTap: () {
        Get.toNamed(
          DI<RouteHelper>().getAgreementDetailScreen(),
          arguments: {"id": agreement.id},
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
            /// Header: Icon + Title + Status Badge
            Row(
              children: [
                /// Agreement icon
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: DI<ColorConst>().secondColorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.description_outlined,
                      color: DI<ColorConst>().secondColorPrimary, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agreement.title,
                        style: DI<CommonWidget>().myTextStyle(
                            DI<ColorConst>().blackColor,
                            16.sp,
                            FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 12, color: DI<ColorConst>().darkGryColor),
                          SizedBox(width: 4),
                          Text(
                            DI<CommonFunction>().formatDate(agreement.createdAt),
                            style: DI<CommonWidget>().myTextStyle(
                                DI<ColorConst>().darkGryColor,
                                12.sp,
                                FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _badge(statusText, statusColor),
              ],
            ),

            /// Signed At (if signed)
            if (agreement.isSigned && agreement.signedAt != null) ...[
              SizedBox(height: 12),
              Divider(
                height: 0,
                thickness: 0.6,
                color: DI<ColorConst>().dividerColor.withOpacity(0.4),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 14, color: DI<ColorConst>().dark_greenColor),
                  SizedBox(width: 6),
                  Text(
                    "${DI<StringConst>().signed_at_text}: ${DI<CommonFunction>().formatDate(agreement.signedAt)}",
                    style: DI<CommonWidget>().myTextStyle(
                        DI<ColorConst>().dark_greenColor,
                        12.sp,
                        FontWeight.w500),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: DI<ColorConst>().darkGryColor),
                ],
              ),
            ] else ...[
              SizedBox(height: 12),
              Divider(
                height: 0,
                thickness: 0.6,
                color: DI<ColorConst>().dividerColor.withOpacity(0.4),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Action required",
                    style: DI<CommonWidget>().myTextStyle(
                        Colors.orange, 12.sp, FontWeight.w500),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: DI<ColorConst>().darkGryColor),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Badge Widget
  Widget _badge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style:
            DI<CommonWidget>().myTextStyle(color, 12.sp, FontWeight.w600),
      ),
    );
  }
}
