import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class NotificationTogleTileWidget extends StatefulWidget {
  final String title;
  const NotificationTogleTileWidget({super.key, required this.title});

  @override
  State<NotificationTogleTileWidget> createState() =>
      _NotificationTogleTileWidgetState();
}

class _NotificationTogleTileWidgetState
    extends State<NotificationTogleTileWidget> {
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
          widget.title,
          style: AppFonts.normalBlack15,
        ),
        trailing: Switch(
          activeColor: AppColors.callToActionColor,
          inactiveThumbColor: AppColors.callToActionColor,
          inactiveTrackColor: const Color.fromARGB(255, 222, 222, 222),
          value: true,
          onChanged: (value) {},
        ),
      ),
    );
  }
}
