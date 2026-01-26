import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../util/ColorConst.dart';
import '../../util/ImageConst.dart';
import '../../util/Injection.dart';
import '../../util/RouteHelper.dart';
import '../../util/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Timer timer;
  bool isLogin = false;
  late AnimationController controller;
  bool determinate = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    isLogin = DI<MyLocalStorage>().getBoolValue(DI<MyLocalStorage>().isLogin);
    print(isLogin);
    controller =
    AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(() {
        setState(() {});
      })
      ..repeat(reverse: true);
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timer =  Timer(Duration(seconds: 3), ()async {

      if(isLogin){
        Get.offAllNamed(DI<RouteHelper>().getHomeTabScreen());
      }else{
        Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DI<ColorConst>().whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(DI<ImageConst>().APP_ICON,width: 100.w,height: 22.w,),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:32.sp),
            child: LinearProgressIndicator(
              value: determinate ? controller.value : null,
              backgroundColor: DI<ColorConst>().dark_greenColor,
              color:DI<ColorConst>().redColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
