import 'dart:developer';
import 'dart:io';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Pages/Home%20Pages/add_remider_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        toolbarHeight: 320,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.callToActionColor,
        flexibleSpace: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const Text("Sweep Schedule", style: AppFonts.normalWhite21),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(30)),
                    height: 260,
                    child: TableCalendar(
                      onDaySelected: (selectedDay, focusedDay) {
                        log(selectedDay.toString());
                      },
                      calendarStyle: const CalendarStyle(
                          markerSize: 20,
                          todayDecoration: BoxDecoration(
                            color: AppColors.callToActionColor,
                            shape: BoxShape.circle,
                          )),
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
            Positioned(
              top: 30,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Remiders",
                    style: TextStyle(
                        color: AppColors.yellowTextColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 35),
                        backgroundColor: AppColors.callToActionColor),
                    onPressed: () {
                      if (Platform.isAndroid) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddReminderPage(),
                        ));
                      } else {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const AddReminderPage(),
                        ));
                      }
                    },
                    child: const Text(
                      "Add Reminder",
                      style: AppFonts.normalWhite15,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.46,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: UniqueKey(),

                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (context) {},
                            backgroundColor:
                                const Color.fromARGB(255, 255, 0, 0),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Remove',
                          ),
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: const Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              title: Text(
                                "Car $index",
                                style: AppFonts.normalBlack18,
                              ),
                              subtitle: const Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        CupertinoIcons.map_pin,
                                        size: 15,
                                        color: AppColors.yellowTextColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Lorem ipsum dolor sit amet.....",
                                        style: TextStyle(
                                            color: Color(0XFF455A64),
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.time,
                                              size: 15,
                                              color: AppColors.yellowTextColor),
                                          SizedBox(width: 10),
                                          Text("09:00 AM")
                                        ],
                                      ),
                                      SizedBox(width: 20),
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.bell,
                                              size: 15,
                                              color: AppColors.yellowTextColor),
                                          SizedBox(width: 10),
                                          Text("30 Mins, 45 Mins ")
                                        ],
                                      )
                                    ],
                                  )
                                ],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Mon",
                                          style: AppFonts.normalBlack13),
                                      Text("16", style: AppFonts.normalBlack13),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index == 4) const SizedBox(height: 40),
                          const SizedBox(height: 4),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
