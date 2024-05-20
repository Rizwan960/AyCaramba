import 'package:ay_caramba/Model/notification_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int money = 0;
  @override
  void initState() {
    getTotalCount();
    super.initState();
  }

  void getTotalCount() {
    for (var notification in NotificationModell().data) {
      if (notification.isVerified) {
        money += notification.saveTicket;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
            )),
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          "History",
          style: TextStyle(color: AppColors.yellowTextColor, fontSize: 30),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('Assets/Json/animation.json', height: 300),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Text(
              "Through our proactive efforts, we've not only saved you from the hassle of tickets but also put money back in your pocket by avoiding fines which is equal to $money as per your ticket fees.",
              style: AppFonts.normalBlack15,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
