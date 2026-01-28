import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/controller/account/account_controller.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/CommonWidget.dart';
import 'package:rupeeglobal/util/ImageConst.dart';
import 'package:rupeeglobal/util/RouteHelper.dart';
import 'package:rupeeglobal/util/StringConst.dart';
import 'package:sizer/sizer.dart';

import '../../../util/ColorConst.dart';
import '../../../util/Injection.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  AccountController accountController = Get.find<AccountController>();
  late ScrollController scrollController;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
    Future.delayed(Duration.zero,() {
      accountController.getNewsList(accountController.page.toString());
    },);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
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
          DI<StringConst>().news_text,
          style: DI<CommonWidget>()
              .myTextStyle(DI<ColorConst>().blackColor, 20, FontWeight.w400),
        ),
      ),
      body: Obx(
        () => accountController.isLoading.value
            ? SizedBox()
            : ListView.separated(
                controller: scrollController,
                itemCount: accountController.newsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.3,
                    color: DI<ColorConst>().whiteColor,

                    child: InkWell(
                      onTap: (){

                        var data = {
                          "imageUrl":accountController.newsList[index].urlToImage.toString(),
                          "title":accountController.newsList[index].title.toString(),
                          "publishedAt":accountController.newsList[index].publishedAt.toString(),
                          "description":accountController.newsList[index].description.toString(),
                        };

                        Get.toNamed(DI<RouteHelper>().getNewsDetailScreen(),parameters: data);

                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FadeInImage.assetNetwork(
                              placeholder: DI<ImageConst>().IMAGE_LOADING,
                              image: accountController.newsList[index].urlToImage,
                              height: 45.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                         // SizedBox(width: 7),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    accountController.newsList[index].title,
                                    style: DI<CommonWidget>().myTextStyle(
                                        DI<ColorConst>().blackColor,
                                        18,
                                        FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    accountController.newsList[index].content,
                                    maxLines: 3,
                                    style: DI<CommonWidget>().myTextStyle(
                                        DI<ColorConst>().blackColor,
                                        13,
                                        FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      DI<StringConst>().view_all_text,
                                      style: DI<CommonWidget>().myTextStyle(
                                          DI<ColorConst>().redColor,
                                          15,
                                          FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
      ),
      bottomNavigationBar: Obx(
        () => accountController.isBottomLoading.value
            ? SizedBox(
                height: kBottomNavigationBarHeight,
                child: Center(
                  child: CircularProgressIndicator(
                    color: DI<ColorConst>().redColor,
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (accountController.isScroll && !accountController.isLoading.value) {
        accountController.page = accountController.page + 1;
        accountController.getNewsList(accountController.page.toString());
      }
    }
  }
}
