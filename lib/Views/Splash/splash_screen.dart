import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ay_caramba/Model/user_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:ay_caramba/Views/BottomNavBar/app_bottom_nav_bar.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/subscription_paywall_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _imageVisible = true;
  bool _svgVisible = false;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _imageVisible = false;
      });

      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _svgVisible = true;
        });

        Timer(const Duration(seconds: 3), () {
          _navigate();
        });
      });
    });
  }

  bool isMoreThan30DaysAgo(DateTime date) {
    DateTime currentDate = DateTime.now();
    int differenceInDays = currentDate.difference(date).inDays;
    return differenceInDays > 30;
  }

  Future<void> _navigate() async {
    final token = await AppSharefPrefHelper.getUserToken();
    log(token.toString());

    if (token.isEmpty || token == "") {
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
      CommonData.userName = currentUser.name;
      CommonData.userEmail = currentUser.email;

      if (isMoreThan30DaysAgo(currentUser.createdAt)) {
        if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SubscriptionPayWallPage(
              showAppBar: false,
            ),
          ));
        } else {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => const SubscriptionPayWallPage(
              showAppBar: false,
            ),
          ));
        }
      } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.callToActionColor,
      body: Stack(
        children: [
          // Full screen image with fade-out animation
          AnimatedOpacity(
            opacity: _imageVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "Assets/Images/tickets.jpeg",
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Branding elements (SVG) with fade-in animation
          AnimatedOpacity(
            opacity: _svgVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: SvgPicture.asset(
                "Assets/Svg/logo.svg",
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
