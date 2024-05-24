import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class ReminderDetailDialog extends StatelessWidget {
  final ParkingReminders data;
  const ReminderDetailDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reminder Details"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Car: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            data.carName,
            style: AppFonts.normalGrey15,
          ),
          const SizedBox(height: 5),
          const Text(
            "Car Model Year: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            data.carModel,
            style: AppFonts.normalGrey15,
          ),
          const SizedBox(height: 5),
          const Text(
            "Car Plate Number: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            data.carNumber,
            style: AppFonts.normalGrey15,
          ),
          const SizedBox(height: 5),
          const Text(
            "Car Color: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            data.color,
            style: AppFonts.normalGrey15,
          ),
          const SizedBox(height: 5),
          const Text(
            "Reminder Day: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            data.days.toString(),
            style: AppFonts.normalGrey15,
          ),
          const SizedBox(height: 5),
          const Text(
            "Reminder Before Time: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            "${data.reminderTime} mins",
            style: AppFonts.normalGrey15,
          ),
          const SizedBox(height: 5),
          const Text(
            "Ticket Fee: ",
            style: AppFonts.boldBlack15,
          ),
          Text(
            data.ticketFees,
            style: AppFonts.normalGrey15,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Okay"),
        )
      ],
    );
  }
}
