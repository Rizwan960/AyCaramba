import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchReminderPage extends StatefulWidget {
  const SearchReminderPage({super.key});

  @override
  State<SearchReminderPage> createState() => _SearchReminderPageState();
}

class _SearchReminderPageState extends State<SearchReminderPage> {
  final emailController = TextEditingController();
  List<ParkingReminders> filteredReminders = [];

  @override
  void initState() {
    super.initState();
    filteredReminders = ParkingRemindersSingleton().tickets;
  }

  void _filterReminders(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredReminders = ParkingRemindersSingleton().tickets;
      } else {
        filteredReminders =
            ParkingRemindersSingleton().tickets.where((reminder) {
          return reminder.carName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              reminder.color.toLowerCase().contains(searchText.toLowerCase()) ||
              reminder.carNumber
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              reminder.carModel
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          "Search Reminders",
          style: TextStyle(color: AppColors.yellowTextColor, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 55,
                width: 370,
                child: TextFormField(
                  cursorColor: Colors.black,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _filterReminders(value),
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
                    labelText: "Search your reminders",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemCount: filteredReminders.length,
                  itemBuilder: (context, index) {
                    final data = filteredReminders[index];
                    return Column(
                      children: [
                        const SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(
                              data.carName,
                              style: AppFonts.normalBlack18,
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.map_pin,
                                      size: 15,
                                      color: AppColors.yellowTextColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      data.street,
                                      style: const TextStyle(
                                          color: Color(0XFF455A64),
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(CupertinoIcons.time,
                                            size: 15,
                                            color: AppColors.yellowTextColor),
                                        const SizedBox(width: 10),
                                        Text(data.time)
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Row(
                                      children: [
                                        const Icon(CupertinoIcons.bell,
                                            size: 15,
                                            color: AppColors.yellowTextColor),
                                        const SizedBox(width: 10),
                                        Text("${data.reminderTime} mins before")
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      CupertinoIcons.bell,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index == 4) const SizedBox(height: 40),
                        const SizedBox(height: 4),
                      ],
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
