import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/CommonFunction.dart';
import '../../../util/CommonWidget.dart';
import '../../../util/ImageConst.dart';
import '../../../util/Injection.dart';
import '../../../util/StringConst.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

  String imageUrl = "", title = "",description = "",publishedAt = "";
  @override
  void initState() {
    super.initState();
    if(Get.parameters["title"] != null){

      imageUrl = Get.parameters["imageUrl"]??"";
      title = Get.parameters["title"]??"";
      publishedAt = Get.parameters["publishedAt"]??"";
      description = Get.parameters["description"]??"";

    }


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
         "",
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            FadeInImage.assetNetwork(
              placeholder: DI<ImageConst>().IMAGE_LOADING,
              image: imageUrl,
              height: 50.w,
              width: 100.w,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 15,
            ),

            Text(
             title,
              maxLines: 3,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  18,
                  FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${DI<CommonFunction>().formatDate(publishedAt.isEmpty ? null : DateTime.tryParse(publishedAt))}",
              maxLines: 3,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().secondColorPrimary,
                  13,
                  FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              maxLines: 3,
              style: DI<CommonWidget>().myTextStyle(
                  DI<ColorConst>().blackColor,
                  13,
                  FontWeight.w400),
            ),

          ],
        ),
      ),
    );
  }
}
