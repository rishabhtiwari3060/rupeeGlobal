import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';
import 'package:rupeeglobal/controller/theme/ThemeController.dart';

import '../controller/account/account_controller.dart';
import '../controller/home_tab/HomeTabController.dart';

class BindingClass extends Bindings{
  @override
  void dependencies() {

    Get.put<ThemeController>(ThemeController(), permanent: true);

    Get.lazyPut<AuthController>(() => AuthController(),fenix: true);

    Get.lazyPut<AccountController>(() => AccountController(),fenix: true);
    Get.lazyPut<HomeTabController>(() => HomeTabController(),fenix: true);

  }

}