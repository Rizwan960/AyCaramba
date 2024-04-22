import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PersonalDetailTileWidget extends StatelessWidget {
  final String title;
  final Icon icon;
  const PersonalDetailTileWidget(
      {super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.whiteColor,
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppFonts.normalBlack13,
        ),
        leading: icon,
      ),
    );
  }
}
