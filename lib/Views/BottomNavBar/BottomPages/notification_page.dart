import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        title: const Text(
          "Notifications",
          style: AppFonts.normalBlack30,
        ),
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                dense: true,
                title: Text(
                  "Car ${index.toString()}",
                  style: AppFonts.normalBlack18,
                ),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.map_pin,
                          color: AppColors.yellowTextColor,
                          size: 15,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet",
                          style:
                              TextStyle(color: Color(0XFF455A64), fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.clock,
                              color: AppColors.yellowTextColor,
                              size: 15,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "09:00 AM",
                              style: AppFonts.normalBlack12,
                            ),
                          ],
                        ),
                        SizedBox(width: 30),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              color: AppColors.yellowTextColor,
                              size: 15,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Wed, 07/08/2024",
                              style: AppFonts.normalBlack12,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              if (index == 14) const SizedBox(height: 80),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
