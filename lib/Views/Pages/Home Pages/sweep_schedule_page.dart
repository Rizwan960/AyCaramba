import 'dart:developer';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SweepSchedulePage extends StatefulWidget {
  const SweepSchedulePage({super.key});

  @override
  State<SweepSchedulePage> createState() => _SweepSchedulePageState();
}

class _SweepSchedulePageState extends State<SweepSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 300,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.callToActionColor,
        flexibleSpace: Column(
          children: [
            const SizedBox(height: 40),
            const Text("Sweep Schedule", style: AppFonts.normalWhite21),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 260,
                child: TableCalendar(
                  onDaySelected: (selectedDay, focusedDay) {
                    log(selectedDay.toString());
                  },
                  calendarStyle: const CalendarStyle(markerSize: 20),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  rowHeight: 30,
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
