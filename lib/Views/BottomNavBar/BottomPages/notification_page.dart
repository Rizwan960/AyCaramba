import 'dart:developer';

import 'package:ay_caramba/Model/notification_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = NotificationModell().data;
  @override
  void initState() {
    super.initState();
    verifyNotification(notifications.last.id);
  }

  Future<void> verifyNotification(int id) async {
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();

      Map<String, dynamic> data = {"id": id};
      log(data.toString());
      Response response = await dio.post(
          "https://mystreetsweeper.com/api/verify-notification",
          data: data);

      if (response.statusCode == 200 &&
          response.data["message"] == "Notification verified successfully" &&
          mounted) {
        Provider.of<NotificationModell>(context, listen: false)
            .updateVerificationStatus(id);
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();

        CommonData.showCustomSnackbar(
            context, "Notification verified Successfully");
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
                                      "Ticket ${data.saveTicket}",
                                      style: AppFonts.normalBlack12,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      if (index == notifications.length - 1)
                        const SizedBox(height: 90),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
