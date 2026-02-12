import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/home_tab/HomeTabController.dart';
import '../../util/ColorConst.dart';
import '../../util/CommonFunction.dart';
import '../../util/CommonWidget.dart';
import '../../util/ImageConst.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';

class PaymentQrDetailScreen extends StatefulWidget {
  const PaymentQrDetailScreen({super.key});

  @override
  State<PaymentQrDetailScreen> createState() => _PaymentQrDetailScreenState();
}

class _PaymentQrDetailScreenState extends State<PaymentQrDetailScreen> {
  final homeTabController = Get.find<HomeTabController>();
  int? _id;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['id'] != null) {
      _id = args['id'] is int ? args['id'] : int.tryParse(args['id'].toString());
      if (_id != null) {
        homeTabController.getPaymentQrDetail(_id!);
      }
    }
  }

  Widget _buildQrImage(String? qrCodeData) {
    if (qrCodeData == null || qrCodeData.isEmpty) {
      return SizedBox(
        height: 72.w,
        width: 72.w,
        child: Image.asset(
          DI<ImageConst>().IMAGE_LOADING,
          fit: BoxFit.cover,
        ),
      );
    }
    try {
      final base64Part = qrCodeData.contains(',') ? qrCodeData.split(',').last : qrCodeData;
      final bytes = base64Decode(base64Part);
      final svgString = utf8.decode(bytes);
      return Container(
        color: Colors.white,
        width: 72.w,
        height: 72.w,
        child: SvgPicture.string(
          svgString,
          fit: BoxFit.contain,
        ),
      );
    } catch (e) {
      return SizedBox(
        height: 72.w,
        width: 72.w,
        child: Image.asset(
          DI<ImageConst>().IMAGE_LOADING,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: DI<ColorConst>().blackColor,
            )),
        title: Text(
          "Payment QR Code Details",
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),
      body: Obx(() {
        if (homeTabController.isPaymentQrDetailLoading.value && homeTabController.paymentQrDetailModel.value == null) {
          return Center(
            child: CircularProgressIndicator(color: DI<ColorConst>().secondColorPrimary),
          );
        }
        final model = homeTabController.paymentQrDetailModel.value;
        if (model == null || !model.success) {
          return Center(
            child: Text(
              model?.message ?? "Failed to load payment details",
              style: DI<CommonWidget>()
                  .myTextStyle(DI<ColorConst>().darkGryColor, 16, FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          );
        }
        final data = model.data;
        final pd = data.paymentDetails;
        final amountStr = DI<CommonFunction>().formatPrice(data.amount, decimalPlaces: 2);
        final assignedStr = DI<CommonFunction>().formatDate(data.createdAt);
        final paymentDateStr = data.paymentDate != null && data.paymentDate!.isNotEmpty
            ? DI<CommonFunction>().formatDate(data.paymentDate)
            : "----";

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: DI<ColorConst>().secondColorPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DI<ColorConst>().secondColorPrimary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  "Payment Pending: Please scan the QR code below and complete the payment of ₹$amountStr.",
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary, 16, FontWeight.w500),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Scan to Pay",
                  style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().darkGryColor, 14, FontWeight.w500),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildQrImage(data.qrCodeData),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: DI<ColorConst>().dark_greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DI<ColorConst>().dark_greenColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Amount",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().blackColor, 16, FontWeight.w600),
                    ),
                    Text(
                      "₹$amountStr",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().dark_greenColor, 22, FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildIHavePaidButton(amountStr),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DI<ColorConst>().gryLightColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DI<ColorConst>().dividerColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long,
                            color: DI<ColorConst>().secondColorPrimary, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Payment Details",
                          style: DI<CommonWidget>().myTextStyle(
                              DI<ColorConst>().blackColor, 18, FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    if (pd != null) ...[
                      if (pd.upiId != null && pd.upiId!.isNotEmpty) rowDataShow("UPI ID", pd.upiId!),
                      if (pd.upiName != null && pd.upiName!.isNotEmpty) rowDataShow("Name", pd.upiName!),
                      if (pd.upiMobile != null && pd.upiMobile!.isNotEmpty) rowDataShow("Mobile", pd.upiMobile!),
                      if (pd.accountNumber != null && pd.accountNumber!.isNotEmpty) rowDataShow("Account Number", pd.accountNumber!),
                      if (pd.ifscCode != null && pd.ifscCode!.isNotEmpty) rowDataShow("IFSC Code", pd.ifscCode!),
                      if (pd.bankName != null && pd.bankName!.isNotEmpty) rowDataShow("Bank Name", pd.bankName!),
                      if (pd.accountHolderName != null && pd.accountHolderName!.isNotEmpty) rowDataShow("Account Holder", pd.accountHolderName!),
                    ],
                    rowDataShow("Status", data.status.isNotEmpty ? data.status : "----",myColor:data.status == "paid"? DI<ColorConst>().dark_greenColor : DI<ColorConst>().redColor),
                    rowDataShow("Payment Date", paymentDateStr),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DI<ColorConst>().secondColorPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DI<ColorConst>().secondColorPrimary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: DI<ColorConst>().secondColorPrimary, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Instructions",
                          style: DI<CommonWidget>()
                              .myTextStyle(DI<ColorConst>().blackColor, 18, FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "1. Open your UPI app (PhonePe, Google Pay, Paytm, etc.)",
                      style: DI<CommonWidget>()
                          .myTextStyle(DI<ColorConst>().secondColorPrimary, 17, FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "2. Scan the QR code shown above",
                      style: DI<CommonWidget>()
                          .myTextStyle(DI<ColorConst>().secondColorPrimary, 17, FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "3. Verify the amount: ₹$amountStr",
                      style: DI<CommonWidget>()
                          .myTextStyle(DI<ColorConst>().secondColorPrimary, 17, FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "4. Complete the payment",
                      style: DI<CommonWidget>()
                          .myTextStyle(DI<ColorConst>().secondColorPrimary, 17, FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '5. Click "I Have Paid" button after payment',
                      style: DI<CommonWidget>()
                          .myTextStyle(DI<ColorConst>().secondColorPrimary, 17, FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildIHavePaidButton(String amountStr) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _id != null
            ? () => homeTabController.markPaymentQrPaid(_id!)
            : null,
        icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
        label: Text(
          DI<StringConst>().i_have_paid_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().whiteColor, 17, FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: DI<ColorConst>().redColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: DI<ColorConst>().redColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget rowDataShow(String title, String value,{Color? myColor}) {
    return Row(
      children: [
        Expanded(
          flex: 0,
          child: Text(
            "$title :",
            style: DI<CommonWidget>()
                .myTextStyle(DI<ColorConst>().blackColor, 15, FontWeight.w700),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: DI<CommonWidget>()
                .myTextStyle(myColor ?? DI<ColorConst>().darkGryColor, 16, FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
