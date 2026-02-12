import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../util/ColorConst.dart';
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

  @override
  void initState() {
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
          "Payment QR Code Details",
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
           "Payment Pending: Please scan the QR code below and complete the payment of ₹10,000.00.",
        style: DI<CommonWidget>().myTextStyle(
            DI<ColorConst>().secondColorPrimary,
            17,
            FontWeight.w500),
            maxLines: 3,),

            SizedBox(
              height: 10,
            ),

            Center(
              child: Text(
                "Scan to Pay",
                style: DI<CommonWidget>().myTextStyle(
                    DI<ColorConst>().blackColor,
                    15,
                    FontWeight.w500),
                maxLines: 3,),
            ),
            FadeInImage.assetNetwork(
              placeholder: DI<ImageConst>().IMAGE_LOADING,
              image: "https://pngimg.com/uploads/qr_code/qr_code_PNG17.png",
              height: 100.w,
              width: 100.w,
              fit: BoxFit.cover,
            ),

            Text(
              "Payment Amount",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  15,
                  FontWeight.w500),
              maxLines: 3,),

            Text(
              "₹10,000.00",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().dark_greenColor,
                  20,
                  FontWeight.w500),
              maxLines: 3,),
            SizedBox(
              height: 10,
            ),

            DI<CommonWidget>().myButton(DI<StringConst>().i_have_paid_text,(){}),
            SizedBox(
              height: 10,
            ),


            Text(
              "Payment Details",
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  18,
                  FontWeight.w700)),
            SizedBox(
              height: 10,
            ),
            rowDataShow("UPI ID"," 9340194444@ptsbi"),
            rowDataShow("Name"," Rohan Parmar"),
            rowDataShow("Mobile"," 9340199999"),
            rowDataShow("Status"," Assigned"),
            rowDataShow("Assigned"," 04-02-2026"),

            SizedBox(
              height: 10,
            ),
            Container(
              width: 100.w,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: DI<ColorConst>().secondColorPrimary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [


                  Text(
                      "Instructions",
                      style: DI<CommonWidget>().myTextStyle(
                          DI<ColorConst>().blackColor,
                          18,
                          FontWeight.w700)),
                  Text("1. Open your UPI app (PhonePe, Google Pay, Paytm, etc.)",style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      17,
                      FontWeight.w500),),
                  Text("2. Scan the QR code shown above",style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      17,
                      FontWeight.w500),),
                  Text("3. Verify the amount: ₹10,000.00",style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      17,
                      FontWeight.w500),),
                  Text("4. Complete the payment",style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      17,
                      FontWeight.w500),),

                  Text("5. Click \"I Have Paid\" button after payment",style: DI<CommonWidget>().myTextStyle(
                      DI<ColorConst>().secondColorPrimary,
                      17,
                      FontWeight.w500),),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget rowDataShow(String title, String value){
    return    Row(
      children: [
        Expanded(
          flex:0,
          child: Text(
            "$title :",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().blackColor,
                15,
                FontWeight.w700),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          flex:1,
          child: Text(
            "$value",
            style: DI<CommonWidget>().myTextStyle(
                DI<ColorConst>().darkGryColor,
                16,
                FontWeight.w500),
          ),
        ),
      ],
    );
  }

}
