import 'package:get/get.dart';
import 'package:rupeeglobal/controller/auth/AuthController.dart';




class BindingClass extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut<AuthController>(() => AuthController());

  }

}