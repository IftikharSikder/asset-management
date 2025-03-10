import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs; // Start with false by default

  Future<void> setLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("logged_in", isLoggedIn.value);
  }

  Future<void> getLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoggedIn.value = pref.getBool("logged_in") ?? false;
  }
}