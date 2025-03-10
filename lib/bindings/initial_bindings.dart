import 'package:asset_management/auth/auth_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final authController = Get.put(AuthController());
    authController.getLoginStatus();
  }
}