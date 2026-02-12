import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/view/account_screen/AccountScreen.dart';
import 'package:rupeeglobal/view/orders_screen/OrderScreen.dart';
import 'package:rupeeglobal/view/portfolio_screen/PortfolioScreen.dart';
import 'package:rupeeglobal/view/watchlist_screen/FundsScreen.dart';
import 'package:sizer/sizer.dart';
import '../../util/ColorConst.dart';
import '../../util/CommonWidget.dart';
import '../../util/Injection.dart';
import '../../util/StringConst.dart';
import '../home_screen/HomeScreen.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {

  var _currentIndex = 0.obs;

  final List<Widget> _screens = [
    HomeScreen(),
    FundsScreen(),
    PortfolioScreen(),
    OrderScreen(),
    AccountScreen()
  ];

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(
     backgroundColor:  DI<ColorConst>().whiteColor,
      body: _screens[_currentIndex.value],
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    _currentIndex.value = 0;
                  },
                  child: bottomNavIcon(
                      _currentIndex.value == 0
                          ? Icons.home
                          : Icons.home_outlined,
                      DI<StringConst>().home_text.toUpperCase(),
                      _currentIndex.value == 0
                          ? DI<ColorConst>().dark_greenColor
                          : DI<ColorConst>().blackColor)),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    _currentIndex.value = 1;
                  },
                  child: bottomNavIcon(
                      _currentIndex.value == 1
                          ? CupertinoIcons.money_euro_circle_fill
                          : CupertinoIcons.money_euro_circle,
                      DI<StringConst>().funds_text.toUpperCase(),
                      _currentIndex.value == 1
                          ? DI<ColorConst>().dark_greenColor
                          : DI<ColorConst>().blackColor)),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    _currentIndex.value = 2;
                  },
                  child: bottomNavIcon(
                      _currentIndex.value == 2
                          ? Icons.add_circle_outlined
                          : Icons.add_circle_outline,
                      DI<StringConst>().portfolio_text.toUpperCase(),
                      _currentIndex.value == 2
                          ? DI<ColorConst>().dark_greenColor
                          : DI<ColorConst>().blackColor)),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    _currentIndex.value = 3;
                  },
                  child: bottomNavIcon(
                      _currentIndex.value == 3
                          ?CupertinoIcons.gift_fill
                          : CupertinoIcons.gift,
                      DI<StringConst>().order_text.toUpperCase(),
                      _currentIndex.value == 3
                          ? DI<ColorConst>().dark_greenColor
                          : DI<ColorConst>().blackColor)),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    _currentIndex.value = 4;
                  },
                  child: bottomNavIcon(
                      _currentIndex.value == 4
                          ? Icons.person
                          : Icons.person_2_outlined,
                      DI<StringConst>().account_text.toUpperCase(),
                      _currentIndex.value == 4
                          ? DI<ColorConst>().dark_greenColor
                          : DI<ColorConst>().blackColor)),
            ),
          ],
        ),
      ),
    ), );
  }


  Widget bottomNavIcon(IconData? iconShow, String title, Color myColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconShow,
          color: myColor,
        ),
        Text(
          title,
          style:
          DI<CommonWidget>().myTextStyle(myColor, 14.sp, FontWeight.w400),
        )
      ],
    );
  }

}
