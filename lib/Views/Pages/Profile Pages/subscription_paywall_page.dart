import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubscriptionPayWallPage extends StatefulWidget {
  final bool showAppBar;
  const SubscriptionPayWallPage({super.key, required this.showAppBar});

  @override
  State<SubscriptionPayWallPage> createState() =>
      _SubscriptionPayWallPageState();
}

class _SubscriptionPayWallPageState extends State<SubscriptionPayWallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SvgPicture.asset("Assets/Svg/subscribe_to_monthly.svg"),
              const SizedBox(height: 30),
              Stack(
                children: [
                  SvgPicture.asset(
                    "Assets/Svg/subscription_box.svg",
                    height: 350,
                    width: double.infinity,
                  ),
                  const Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Icon(
                      CupertinoIcons.paperplane_fill,
                      color: AppColors.callToActionColor,
                      size: 60,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.callToActionColor,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {},
                  child: const Text(
                    "Pay Now",
                    style: AppFonts.normalWhite18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
