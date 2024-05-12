import 'dart:io';

import 'package:ay_caramba/Controller/get_all_notifications.dart';
import 'package:ay_caramba/Controller/get_all_reminders.dart';
import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Model/user_model.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Pages/Home%20Pages/history_page.dart';
import 'package:ay_caramba/Views/Pages/Home%20Pages/sweep_schedule_page.dart';
import 'package:ay_caramba/Views/Pages/search_reminder_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();
  User user = User.instance;

  @override
  void initState() {
    super.initState();
    loadStoredToken();
    hitForreminders();
  }

  Future<void> hitForreminders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await GetAllReminders().addNewReminder(context, false);
    await Future.delayed(const Duration(milliseconds: 100));
    await GetAllNotifications().getAllNotifications(context);
    setState(() {});
  }

  Future<void> loadStoredToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    CommonData.fcmTocken = await messaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken;
    storedToken = prefs.getString('fcm_token');
    if (storedToken == null) {
      prefs.setString("fcm_token", CommonData.fcmTocken.toString());
      await hitFcmTokenApi(CommonData.fcmTocken);
      return;
    } else if (storedToken == CommonData.fcmTocken) {
      return;
    } else if (storedToken != CommonData.fcmTocken) {
      await hitFcmTokenApi(CommonData.fcmTocken);
    }
  }

  Future<void> hitFcmTokenApi(String? token) async {
    try {
      Dio dio = await CommonData.createDioWithAuthHeaderForFcm();
      final Map<String, dynamic> data = {"token": CommonData.fcmTocken};
      Response response =
          await dio.post(AppApi.addUpdateRemoveFcmToken, data: data);

      if (response.statusCode == 200 &&
          (response.data['message'] == "FCM Token Added Successfully" ||
              response.data['message'] == "FCM Token Updated Successfully" ||
              response.data['message'] == "FCM token updated successfully")) {
        if (mounted) {
          CommonData.showCustomSnackbar(
              context, "Notification settings updated");
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
          CommonData.showCustomSnackbar(context, "No internet connection");
        }
      } else {
        if (mounted) {
          CommonData.sshowDialog('Error', e.response!.data['message'], context);
        }
      }
    } catch (e) {
      if (mounted) {
        CommonData.sshowDialog(
            "Unexpected behaviour",
            "An un-expected error accourd restarting your app might resolve this issue",
            context);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            toolbarHeight: 200,
            flexibleSpace: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "Assets/Images/home_appbar.png",
                    width: MediaQuery.of(context).size.width,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 20,
                  child: Text(
                    "Hello ${user.name}!",
                    style:
                        const TextStyle(color: Color(0XFFE3E3E3), fontSize: 22),
                  ),
                ),
                const Positioned(
                  top: 130,
                  left: 20,
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      "Let's Track your street cleaning schedule",
                      style: AppFonts.normalWhite15,
                    ),
                  ),
                ),
                Positioned(
                    top: 100,
                    right: 20,
                    child: SvgPicture.asset(
                      "Assets/Svg/logo.svg",
                      height: 80,
                    ))
              ],
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      if (ParkingRemindersSingleton().tickets.isEmpty) {
                        GetAllReminders().addNewReminder(context, true);
                      } else {
                        if (Platform.isAndroid) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SweepSchedulePage(),
                          ));
                        } else {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const SweepSchedulePage(),
                          ));
                        }
                      }
                    },
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 174, 148, 120),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  "Sweep Schedule",
                                  style: TextStyle(
                                      color: AppColors.yellowTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    "Sweeper's near, move your gear!",
                                    style: AppFonts.normalGrey12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SvgPicture.asset("Assets/Svg/sweep.svg",
                                height:
                                    MediaQuery.of(context).size.width * 0.16),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      if (Platform.isAndroid) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ));
                      } else {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const HistoryPage(),
                        ));
                      }
                    },
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 174, 148, 120),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  "History",
                                  style: TextStyle(
                                      color: AppColors.yellowTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Track your wins: tickets dodged, savings begin!",
                                    style: AppFonts.normalGrey12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SvgPicture.asset("Assets/Svg/history.svg",
                                height:
                                    MediaQuery.of(context).size.width * 0.22),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Reminders",
                    style: AppFonts.normalBlack18,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: ParkingRemindersSingleton().tickets.isEmpty
                        ? const Center(
                            child: Text("No reminders added yet"),
                          )
                        : ListView.builder(
                            itemCount:
                                ParkingRemindersSingleton().tickets.length,
                            itemBuilder: (context, index) {
                              final data =
                                  ParkingRemindersSingleton().tickets[index];
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      title: Text(
                                        data.carName,
                                        style: AppFonts.normalBlack18,
                                      ),
                                      subtitle: Text(
                                        data.street,
                                        style: const TextStyle(
                                            color: Color(0XFF455A64),
                                            fontSize: 13),
                                      ),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          height: 50,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.yellowTextColor),
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                CupertinoIcons.bell,
                                                color: Colors.white,
                                              )
                                              // Text(data.days[0].substring(0, 3),
                                              //     style:
                                              //         AppFonts.normalBlack13),
                                              // if (data.days.length > 1)
                                              //   Text(
                                              //       data.days[1]
                                              //           .substring(0, 3),
                                              //       style:
                                              //           AppFonts.normalBlack13),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 215,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 55,
            width: 370,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                cursorColor: Colors.black,
                readOnly: true,
                onTap: () {
                  if (Platform.isAndroid) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchReminderPage(),
                    ));
                  } else {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const SearchReminderPage(),
                    ));
                  }
                },
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                controller: emailController,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {},
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    size: 20,
                  ),
                  fillColor: AppColors.whiteColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: AppColors.blackColor)),
                  hintText: "Search your reminders",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
