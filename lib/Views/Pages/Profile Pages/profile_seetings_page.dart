import 'dart:io';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Auth/reset_password_page.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/personal_detail_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileSeetingsPage extends StatefulWidget {
  const ProfileSeetingsPage({super.key});

  @override
  State<ProfileSeetingsPage> createState() => _ProfileSeetingsPageState();
}

class _ProfileSeetingsPageState extends State<ProfileSeetingsPage> {
  void _showEditOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            "What you want to update?",
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Name',
                style: AppFonts.normalBlack13,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Handle email editing
                Navigator.pop(context);
              },
              child: const Text(
                'Email',
                style: AppFonts.normalBlack13,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Handle phone number editing
                Navigator.pop(context);
              },
              child: const Text(
                'Phone Number',
                style: AppFonts.normalBlack13,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void _showEditOptionsForAndroid(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text("What you want to update?"),
            ListTile(
              title: const Text('Name'),
              onTap: () {
                // Handle name editing
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Email'),
              onTap: () {
                // Handle email editing
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Phone Number'),
              onTap: () {
                // Handle phone number editing
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Center(
                  child: Text('Cancel', style: TextStyle(color: Colors.red))),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        title: const Text(
          "Profile Settings",
          style: AppFonts.normalBlack21,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Personal Details",
                    style: TextStyle(
                        color: AppColors.yellowTextColor, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          _showEditOptionsForAndroid(context);
                        } else {
                          _showEditOptions(context);
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.pencil,
                        color: AppColors.callToActionColor,
                      ))
                ],
              ),
              const SizedBox(height: 10),
              const PersonalDetailTileWidget(
                title: "Leo Thomas",
                icon: Icon(
                  CupertinoIcons.person_alt_circle,
                  color: AppColors.yellowTextColor,
                ),
              ),
              const SizedBox(height: 10),
              const PersonalDetailTileWidget(
                title: "Leaothomas45@dummy.com",
                icon: Icon(
                  CupertinoIcons.mail_solid,
                  color: AppColors.yellowTextColor,
                ),
              ),
              const SizedBox(height: 10),
              const PersonalDetailTileWidget(
                title: "360-410-6716",
                icon: Icon(
                  CupertinoIcons.phone_circle_fill,
                  color: AppColors.yellowTextColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Password",
                    style: TextStyle(
                        color: AppColors.yellowTextColor, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          ));
                        } else {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          ));
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.pencil,
                        color: AppColors.callToActionColor,
                      ))
                ],
              ),
              const SizedBox(height: 10),
              const PersonalDetailTileWidget(
                title: "*********",
                icon: Icon(
                  CupertinoIcons.lock_circle_fill,
                  color: AppColors.yellowTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red.shade200,
          ),
          child: const ListTile(
            title: Text(
              "Delete Account",
              style: AppFonts.normalBlack13,
            ),
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            trailing: Icon(
              CupertinoIcons.xmark,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
