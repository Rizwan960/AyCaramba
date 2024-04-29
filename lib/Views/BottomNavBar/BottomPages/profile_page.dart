import 'dart:io';

import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/profile_seetings_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/referral_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/subscription_paywall_page.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/email_name_tile_widget.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/notification_togle_tile_widget.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/single_title_tile_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> logout() async {
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();

    try {
      Dio dio = await CommonData.createDioWithAuthHeader();

      Response response = await dio.get(AppApi.logoutUrl);
      if (response.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.clear();
        if (mounted) {
          if (Platform.isAndroid) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false);
          }
        }
      } else {
        if (mounted) {
          CommonData.sshowDialog("Error", response.data['message'], context);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        if (mounted) {
          Provider.of<LoadingManagemet>(context, listen: false)
              .changeApiHittingBehaviourToFalse();

          CommonData.showCustomSnackbar(context, "No internet connection");
        }
      } else {
        if (mounted) {
          Provider.of<LoadingManagemet>(context, listen: false)
              .changeApiHittingBehaviourToFalse();

          if (mounted) {
            CommonData.sshowDialog(
                'Error', e.response!.data['message'], context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
      }

      if (mounted) {
        CommonData.sshowDialog(
            "Unexpected behaviour",
            "An un-expected error accourd restarting your app might resolve this issue",
            context);
      }
      rethrow;
    }
    if (mounted) {
      Provider.of<LoadingManagemet>(context, listen: false)
          .changeApiHittingBehaviourToFalse();
    }
  }

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
                name: CommonData.userName,
                email: CommonData.userEmail,
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
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppColors.whiteColor,
                        title: const Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text("Are you sure?"),
                          ],
                        ),
                        content: const Text(
                          "Are you sure you want to logout?",
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.callToActionColor,
                                    minimumSize: const Size.fromHeight(45)),
                                child: const Text(
                                  'Yes',
                                  style: AppFonts.normalWhite18,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  logout();
                                },
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.callToActionColor,
                                    minimumSize: const Size.fromHeight(45)),
                                child: const Text(
                                  'Cancel',
                                  style: AppFonts.normalWhite18,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
