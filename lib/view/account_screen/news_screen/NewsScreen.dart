import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/CommonWidget.dart';
import 'package:rupeeglobal/util/StringConst.dart';

import '../../../util/ColorConst.dart';
import '../../../util/Injection.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  AccountController accountController = Get.find<AccountController>();
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    accountController.getNewsList("20");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(onTap: (){
          Get.back();
        }, child: Icon(Icons.arrow_back_ios,color: DI<ColorConst>().blackColor,)),
        title: Text(DI<StringConst>().news_text,
          style: DI<CommonWidget>().myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [

          ],
        ),
      ),
     
    );
  }
}
