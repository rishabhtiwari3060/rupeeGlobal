import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';

import '../controller/account/account_controller.dart';




class BindingClass extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<AccountController>(() => AccountController());

  }

}