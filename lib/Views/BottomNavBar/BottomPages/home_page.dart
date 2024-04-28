import 'dart:io';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Pages/Home%20Pages/history_page.dart';
import 'package:ay_caramba/Views/Pages/Home%20Pages/sweep_schedule_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();

  Future<void> setUserData() async {
    final data = await AppSharefPrefHelper.getUserNameAndEmail();

    CommonData.userName = data[0];
    CommonData.userEmail = data[1];
    CommonData.userPhone = data[2];
    CommonData.userPhoto = data[9];
    CommonData.userCode = data[5];
    CommonData.isUserSubscribed = data[6];
    CommonData.isWin = data[7];
    CommonData.isCodeValid = data[8];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            toolbarHeight: 158,
            flexibleSpace: Stack(
              children: [
                Image.asset("Assets/Images/home_appbar.png"),
                Positioned(
                  top: 60,
                  left: 20,
                  child: Text(
                    "Hello ${CommonData.userName}!",
                    style:
                        const TextStyle(color: Color(0XFFE3E3E3), fontSize: 20),
                  ),
                ),
                const Positioned(
                  top: 100,
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
                    top: 80,
                    right: 20,
                    child: SvgPicture.asset(
                      "Assets/Svg/logo.svg",
                      height: 60,
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
                      if (Platform.isAndroid) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SweepSchedulePage(),
                        ));
                      } else {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const SweepSchedulePage(),
                        ));
                      }
                    },
                    child: Container(
                      height: 110,
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
                      height: 110,
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
                    "This Week",
                    style: AppFonts.normalBlack18,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                title: Text(
                                  "Car $index",
                                  style: AppFonts.normalBlack18,
                                ),
                                subtitle: const Text(
                                  "Lorem ipsum dolor sit amet, consetetur…….",
                                  style: TextStyle(
                                      color: Color(0XFF455A64), fontSize: 13),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    height: 50,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.yellowTextColor),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Mon",
                                            style: AppFonts.normalBlack13),
                                        Text("16",
                                            style: AppFonts.normalBlack13),
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
          top: 175,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 55,
            width: 370,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                cursorColor: Colors.black,
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
                  labelText: "Search your remiders",
                  labelStyle: TextStyle(color: Colors.black),
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
