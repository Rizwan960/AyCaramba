import 'dart:developer';
import 'dart:io';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Widgets/TextField/auth_text_field_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  String _selectedTimeFrame = '30 mins';
  bool showError = false;
  bool rememberMe = false;

  final key = GlobalKey<FormState>();
  final carNameController = TextEditingController();
  final carNumberController = TextEditingController();
  final carModelController = TextEditingController();
  final carParkLocationController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  final String _selectedPeriod = 'AM';

  final carNameFocusNode = FocusNode();
  final carNumberFocusNode = FocusNode();
  final carModelFocusNode = FocusNode();
  final carParkLocationFocusNode = FocusNode();
  final List<String> items = [
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
    'Every Sunday',
    'Every Monday and Tuesday',
    'Every Monday and Wednesday',
    'Every Monday and Thursday',
    'Every Monday and Friday',
    'Every Monday and Saturday',
    'Every Monday and Sunday',
    'Every Tuesday and Wednesday',
    'Every Tuesday and Thursday',
    'Every Tuesday and Friday',
    'Every Tuesday and Saturday',
    'Every Tuesday and Sunday',
    'Every Wednesday and Thursday',
    'Every Wednesday and Friday',
    'Every Wednesday and Saturday',
    'Every Wednesday and Sunday',
    'Every Thursday and Friday',
    'Every Thursday and Saturday',
    'Every Thursday and Sunday',
    'Every Friday and Saturday',
    'Every Friday and Sunday',
    'Every Saturday and Sunday',
    "Custom"
  ];
  String? selectedValue;
  @override
  void dispose() {
    carModelFocusNode.dispose();
    carNameFocusNode.dispose();
    carNumberFocusNode.dispose();
    carParkLocationFocusNode.dispose();
    super.dispose();
  }

  Widget _buildTimeFrameContainer(String timeFrame) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeFrame = timeFrame;
          if (timeFrame == 'Custom') {
            _showCustomTimeDialog();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _selectedTimeFrame == timeFrame
              ? AppColors.callToActionColor
              : Colors.transparent,
          border: Border.all(color: AppColors.callToActionColor),
        ),
        child: Text(
          timeFrame,
          style: TextStyle(
            color: _selectedTimeFrame == timeFrame
                ? Colors.white
                : AppColors.callToActionColor,
          ),
        ),
      ),
    );
  }

  void _showCustomTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int customMinutes = 0;

        return AlertDialog(
          title: const Text('Enter Custom Minutes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  labelText: "Enter custom time in mins",
                  labelStyle: TextStyle(color: Colors.grey),
                  // fillColor: AppColors.whiteColor,
                  // filled: true,
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  customMinutes = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.callToActionColor,
                    minimumSize: const Size.fromHeight(45)),
                onPressed: () {
                  setState(() {
                    _selectedTimeFrame = '$customMinutes mins';
                  });
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Okay",
                  style: AppFonts.normalWhite18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
          "Add Reminder",
          style: TextStyle(color: AppColors.yellowTextColor, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Center(
                    child: Text("Car Details", style: AppFonts.normalBlack18)),
                const SizedBox(height: 20),
                AuthTextFieldWidget(
                  controller: carNameController,
                  focusNode: carNameFocusNode,
                  leadingIcon: const Icon(Icons.abc_outlined),
                  textInputType: TextInputType.text,
                  hintText: "Car Name",
                  nextFocusNode: carNumberFocusNode,
                  isLastField: false,
                  validationReqired: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                AuthTextFieldWidget(
                  controller: carNumberController,
                  focusNode: carNumberFocusNode,
                  leadingIcon: const Icon(Icons.numbers),
                  textInputType: TextInputType.number,
                  hintText: "Car Number",
                  nextFocusNode: carModelFocusNode,
                  isLastField: false,
                  validationReqired: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                AuthTextFieldWidget(
                  controller: carModelController,
                  focusNode: carModelFocusNode,
                  leadingIcon: const Icon(Icons.numbers),
                  textInputType: TextInputType.number,
                  hintText: "Car Model",
                  nextFocusNode: carParkLocationFocusNode,
                  isLastField: false,
                  validationReqired: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                AuthTextFieldWidget(
                  controller: carParkLocationController,
                  focusNode: carParkLocationFocusNode,
                  leadingIcon: const Icon(CupertinoIcons.map_pin),
                  textInputType: TextInputType.text,
                  hintText: "Car Park Street Address",
                  nextFocusNode: carParkLocationFocusNode,
                  isLastField: false,
                  validationReqired: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                const Center(
                    child: Text("Set Time", style: AppFonts.normalBlack18)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 130,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.now(),
                    itemExtent: 30, // Adjust according to your preference
                    onDateTimeChanged: (index) {
                      setState(() {
                        // Update selected time
                        _selectedTime = DateTime(
                          _selectedTime.year,
                          _selectedTime.month,
                          _selectedTime.day,
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                    child: Text("Set Day", style: AppFonts.normalBlack18)),
                const SizedBox(height: 20),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: AppColors.yellowTextColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select Day',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.yellowTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.yellowTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                      if (selectedValue == "Custom") {
                        log("Halu");
                      }
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: AppColors.callToActionColor,
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.yellowTextColor,
                      ),
                      iconSize: 14,
                      iconEnabledColor: AppColors.yellowTextColor,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: AppColors.callToActionColor,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(6),
                        thumbVisibility: MaterialStateProperty.all(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                    child:
                        Text("Remind Before", style: AppFonts.normalBlack18)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimeFrameContainer('30 mins'),
                    _buildTimeFrameContainer('1 hour'),
                    _buildTimeFrameContainer('12 hours'),
                    _buildTimeFrameContainer('Custom'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      activeColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      side: BorderSide(color: Colors.grey.shade600),
                      fillColor: rememberMe
                          ? null
                          : MaterialStateProperty.all<Color>(Colors.white),
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                          log(rememberMe.toString());
                          if (rememberMe) {
                            showError = false;
                          } else {
                            showError = true;
                          }
                          log(showError.toString());
                        });
                      },
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 244, 194, 172),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "By using this application, I acknowledge and agree that the accuracy of information shared by users is not guaranteed by the application and its developers.",
                            style: AppFonts.normalBlack15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Required",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.callToActionColor,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: false
                      ? Center(
                          child: Platform.isAndroid
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                        )
                      : const Text(
                          "Add Reminder",
                          style: AppFonts.normalWhite18,
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}