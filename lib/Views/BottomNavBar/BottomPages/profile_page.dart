import 'dart:io';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/profile_seetings_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/referral_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/subscription_paywall_page.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/email_name_tile_widget.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/notification_togle_tile_widget.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/single_title_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Profile",
                style:
                    TextStyle(color: AppColors.yellowTextColor, fontSize: 30),
              ),
              const SizedBox(height: 10),
              EmailNameTileWidget(
                name: "Leo Thomas",
                email: "Leaothomas45@dummy.com",
                fun: () {
                  if (Platform.isAndroid) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileSeetingsPage(),
                    ));
                  } else {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const ProfileSeetingsPage(),
                    ));
                  }
                },
              ),
              const SizedBox(height: 10),
              SingleTitleTileWidget(
                title: "Referral ",
                fun: () {
                  if (Platform.isAndroid) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReferralPage(),
                    ));
                  } else {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const ReferralPage(),
                    ));
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "General",
                style:
                    TextStyle(color: AppColors.yellowTextColor, fontSize: 30),
              ),
              const SizedBox(height: 10),
              const NotificationTogleTileWidget(title: "Mute Notifications"),
              const SizedBox(height: 10),
              SingleTitleTileWidget(
                title: "Get Premium Now",
                fun: () {
                  if (Platform.isAndroid) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubscriptionPayWallPage(
                        showAppBar: true,
                      ),
                    ));
                  } else {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const SubscriptionPayWallPage(
                        showAppBar: true,
                      ),
                    ));
                  }
                },
              ),
              const SizedBox(height: 10),
              SingleTitleTileWidget(
                title: "Privacy Policy ",
                fun: () async {
                  final Uri url = Uri.parse("https://www.google.com");
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              const SizedBox(height: 10),
              SingleTitleTileWidget(
                title: "Terms & Conditions",
                fun: () async {
                  final Uri url = Uri.parse("https://www.google.com");
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              const SizedBox(height: 10),
              SingleTitleTileWidget(
                title: "Logout",
                fun: () {
                  if (Platform.isAndroid) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
