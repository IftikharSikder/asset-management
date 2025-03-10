import 'package:asset_management/auth/auth_controller.dart';
import 'package:asset_management/screens/homepage_screen.dart';
import 'package:asset_management/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {

      if(authController.isLoggedIn.value){
        if(mounted){
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageScreen()), //-->
          );
        }
      }
      else{
        if(mounted){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Welcome to My App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
