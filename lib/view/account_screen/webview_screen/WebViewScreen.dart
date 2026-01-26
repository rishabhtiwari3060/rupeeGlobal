import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/Injection.dart';


class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  String webUrl = "";
  String screenType = "";
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    webUrl = Get.parameters["url"]??"";
    screenType = Get.parameters["screenType"]??"";
    print("WebUrl :-- $webUrl -- screenType :-- $screenType");
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios,color: DI<ColorConst>().blackColor,),
          ),
          title: Text(screenType,
            style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 17.sp, FontWeight.w400),),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: DI<ColorConst>().whiteColor,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(webUrl),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            print("Started loading: $url");
            DI<CommonFunction>().showLoading();
          },
          onLoadStop: (controller, url) {
            print("Finished loading: $url");
            DI<CommonFunction>().hideLoader();
          },
          onReceivedError: (controller, request, error) {
            print("Error: $error");
            DI<CommonFunction>().hideLoader();
          },
        ),
      ),
    );
  }
}

