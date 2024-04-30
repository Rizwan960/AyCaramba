import 'dart:io';

import 'package:ay_caramba/Model/user_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:ay_caramba/Views/BottomNavBar/app_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkToken() async {
    final token = await AppSharefPrefHelper.getUserToken();

    await Future.delayed(const Duration(seconds: 2));
    if (token == "") {
      if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      } else {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => const LoginPage(),
        ));
      }
    } else {
      User currentUser = await AppSharefPrefHelper.getUser();
      await Future.delayed(const Duration(seconds: 2));

      if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AppBottomNavBar(),
        ));
      } else {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => const AppBottomNavBar(),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.callToActionColor,
      body: Center(
        child: SvgPicture.asset("Assets/Svg/logo.svg"),
      ),
    );
  }
}
