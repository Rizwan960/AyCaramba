import 'dart:developer';

import 'package:ay_caramba/Controller/add_reminder_controller.dart';
import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Widgets/TextField/auth_text_field_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddReminderPage extends StatefulWidget {
  ParkingReminders? parkingReminders;
  AddReminderPage({super.key, this.parkingReminders});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  String _selectedTimeFrame = '30 mins';
  bool showError = false;
  bool rememberMe = false;
  String formattedDate = "";
  final key = GlobalKey<FormState>();
  final carNameController = TextEditingController();
  final carNumberController = TextEditingController();
  final carModelController = TextEditingController();
  final carColorController = TextEditingController();
  final carfineController = TextEditingController();
  final carParkLocationController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  final String _selectedPeriod = 'AM';
  final carNameFocusNode = FocusNode();
  final carNumberFocusNode = FocusNode();
  final carModelFocusNode = FocusNode();
  final carColorFocusNode = FocusNode();
  final carFineFocusNode = FocusNode();
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

  DateTime convertToOriginalDateTime(String formattedTime) {
    List<String> parts = formattedTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].split(' ')[0]);
    String period = parts[1].split(' ')[1];

    if (period == 'am' && hour == 12) {
      hour = 0;
    } else if (period == 'pm' && hour != 12) {
      hour += 12;
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  @override
  void initState() {
    super.initState();
    updateRecordCheck();
  }

  Future<void> updateRecordCheck() async {
    if (widget.parkingReminders != null) {
      carNameController.text = widget.parkingReminders!.carName;
      carNumberController.text = widget.parkingReminders!.carNumber;
      carModelController.text = widget.parkingReminders!.carModel;
      carColorController.text = widget.parkingReminders!.color;
      carParkLocationController.text = widget.parkingReminders!.street;
      carfineController.text = widget.parkingReminders!.ticketFees;
      _selectedTime = convertToOriginalDateTime(widget.parkingReminders!.time);
      selectedValue = revertDays(widget.parkingReminders!.days);
      setState(() {});
    }
  }

  List<String> extractDays(String selectedItem) {
    if (selectedItem.startsWith("Every ")) {
      selectedItem = selectedItem.substring("Every ".length);
    }
    List<String> days = selectedItem.split(" and ");
    List<String> result = [];
    for (String day in days) {
      List<String> parts = day.split(' ');
      result.add(parts.last);
    }

    return result;
  }

  String revertDays(List<String> extractedDays) {
    if (extractedDays.isEmpty) return ''; // Handle empty list case

    String prefix = 'Every';
    String result = '$prefix ${extractedDays.join(' and ')}';

    return result;
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
                  CommonData.showCustomSnackbar(
                      context, "Custom time selected");
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

  Future<void> checkForm() async {
    final isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    key.currentState!.save();
    widget.parkingReminders == null
        ? AddReminderController().addNewReminder(
            carNameController.text,
            carNumberController.text,
            carModelController.text,
            carColorController.text,
            carParkLocationController.text,
            formattedDate,
            extractDays(selectedValue.toString()),
            _selectedTimeFrame,
            carfineController.text,
            context,
          )
        : AddReminderController().addNewReminder(
            carNameController.text,
            carNumberController.text,
            carModelController.text,
            carColorController.text,
            carParkLocationController.text,
            formattedDate,
            extractDays(selectedValue.toString()),
            _selectedTimeFrame,
            carfineController.text,
            context,
            widget.parkingReminders!.id.toString(),
            true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingManagemet>(
      builder: (context, value, _) {
        return Stack(
          children: [
            Scaffold(
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
                title: widget.parkingReminders == null
                    ? const Text(
                        "Add Reminder",
                        style: TextStyle(
                            color: AppColors.yellowTextColor, fontSize: 25),
                      )
                    : const Text(
                        "Update Reminder",
                        style: TextStyle(
                            color: AppColors.yellowTextColor, fontSize: 25),
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
                            child: Text("Car Details",
                                style: AppFonts.normalBlack18)),
                        const SizedBox(height: 20),
                        AuthTextFieldWidget(
                          controller: carNameController,
                          focusNode: carNameFocusNode,
                          leadingIcon: const Icon(Icons.abc_outlined,
                              color: Colors.grey),
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
                          leadingIcon:
                              const Icon(Icons.numbers, color: Colors.grey),
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
                          leadingIcon:
                              const Icon(Icons.numbers, color: Colors.grey),
                          textInputType: TextInputType.number,
                          hintText: "Car Model",
                          nextFocusNode: carColorFocusNode,
                          isLastField: false,
                          validationReqired: true,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 10),
                        AuthTextFieldWidget(
                          controller: carColorController,
                          focusNode: carColorFocusNode,
                          leadingIcon:
                              const Icon(Icons.color_lens, color: Colors.grey),
                          textInputType: TextInputType.text,
                          hintText: "Car Color",
                          nextFocusNode: carParkLocationFocusNode,
                          isLastField: false,
                          validationReqired: true,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 10),
                        AuthTextFieldWidget(
                          controller: carParkLocationController,
                          focusNode: carParkLocationFocusNode,
                          leadingIcon: const Icon(CupertinoIcons.map_pin,
                              color: Colors.grey),
                          textInputType: TextInputType.text,
                          hintText: "Car Park Street Address",
                          nextFocusNode: carParkLocationFocusNode,
                          isLastField: false,
                          validationReqired: true,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 20),
                        const Center(
                            child: Text("Set Time",
                                style: AppFonts.normalBlack18)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 130,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: _selectedTime,
                            itemExtent:
                                30, // Adjust according to your preference
                            onDateTimeChanged: (index) {
                              setState(() {
                                _selectedTime = index;
                              });
                              formattedDate = _selectedTime.hour > 12
                                  ? '${_selectedTime.hour - 12}:${_selectedTime.minute.toString().padLeft(2, '0')} pm'
                                  : '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')} am';
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                            child:
                                Text("Set Day", style: AppFonts.normalBlack18)),
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
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
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
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
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
                            child: Text("Remind Before",
                                style: AppFonts.normalBlack18)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTimeFrameContainer('30 mins'),
                            _buildTimeFrameContainer('60 mins'),
                            _buildTimeFrameContainer('12 hours'),
                            _buildTimeFrameContainer('Custom'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Center(
                            child: Text("Ticket Fee",
                                style: AppFonts.normalBlack18)),
                        const SizedBox(height: 20),
                        AuthTextFieldWidget(
                          controller: carfineController,
                          focusNode: carFineFocusNode,
                          leadingIcon:
                              const Icon(Icons.money, color: Colors.grey),
                          textInputType: TextInputType.number,
                          hintText: "Ticket Fee",
                          nextFocusNode: carFineFocusNode,
                          isLastField: false,
                          validationReqired: true,
                          textInputAction: TextInputAction.done,
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
                                  : MaterialStateProperty.all<Color>(
                                      Colors.white),
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
                                    color: const Color.fromARGB(
                                        255, 244, 194, 172),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
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
                            checkForm();
                          },
                          child: widget.parkingReminders == null
                              ? const Text(
                                  "Add Reminder",
                                  style: AppFonts.normalWhite18,
                                )
                              : const Text(
                                  "Update Reminder",
                                  style: AppFonts.normalWhite18,
                                ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (value.isApiHitting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SizedBox(
                    height: 50,
                    child: SpinKitFoldingCube(
                      color: AppColors.callToActionColor,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
