import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailNameTileWidget extends StatelessWidget {
  final String name;
  final String email;
  final Function() fun;
  const EmailNameTileWidget(
      {super.key, required this.name, required this.email, required this.fun});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.whiteColor,
      ),
      child: ListTile(
        onTap: fun,
        title: Text(
          name,
          style: AppFonts.normalBlack18,
        ),
        subtitle: Text(
          email,
          style: AppFonts.normalGrey12,
        ),
        trailing: const Icon(CupertinoIcons.forward),
      ),
    );
  }
}
