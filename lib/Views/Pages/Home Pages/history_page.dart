import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
      body: const Center(
        child: Text(
          "Under Development",
          style: AppFonts.normalBlack25,
        ),
      ),
    );
  }
}
