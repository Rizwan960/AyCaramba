import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleTitleTileWidget extends StatelessWidget {
  final String title;
  const SingleTitleTileWidget({super.key, required this.title});

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
          style: AppFonts.normalBlack15,
        ),
        trailing: const Icon(CupertinoIcons.forward),
      ),
    );
  }
}
