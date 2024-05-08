import 'package:ay_caramba/Model/notification_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = NotificationModel().data;
  Future<void> refresh() async {}
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
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications",
                style: AppFonts.normalBlack15,
              ),
            )
          : RefreshIndicator(
              backgroundColor: AppColors.callToActionColor,
              color: Colors.white,
              onRefresh: () => refresh(),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final data = notifications[index];
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        title: Text(
                          data.carName,
                          style: AppFonts.normalBlack18,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.map_pin,
                                  color: AppColors.yellowTextColor,
                                  size: 15,
                                ),
                                Text(
                                  data.street,
                                  style: const TextStyle(
                                      color: Color(0XFF455A64), fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.clock,
                                      color: AppColors.yellowTextColor,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      data.time,
                                      style: AppFonts.normalBlack12,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 30),
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.money_dollar,
                                      color: AppColors.yellowTextColor,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Ticket \$${data.saveTicket}",
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
            ),
    );
  }
}
