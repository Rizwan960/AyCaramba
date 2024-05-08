import 'package:ay_caramba/Controller/add_reminder_controller.dart';
import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Widgets/TextField/auth_text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AddReminderPage extends StatefulWidget {
  ParkingReminders? parkingReminders;
  AddReminderPage({super.key, this.parkingReminders});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  String _selectedTimeFrame = '30 mins';
  String? _selectedOption;
  bool showError = false;
  final Map<DateTime, List<dynamic>> _events = {};
  final List<DateTime> _selectedDates = [];
  bool rememberMe = true;
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
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
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

    // If the time is PM and not already in 24-hour format, add 12 hours
    if (formattedTime.contains('pm') && hour < 12) {
      hour += 12;
    }

    // If the time is AM and it's 12 AM, convert it to 00 hours
    if (formattedTime.contains('am') && hour == 12) {
      hour = 0;
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  DateTime _selectedDate = DateTime.now();
  final List<String> _dayOptions = [
    'Daily',
    'Weekly on ',
    'Monthly on the ',
    'Every weekday (Mon-Fri)',
    'Custom'
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedOption = _getOptionsBasedOnDate(_selectedDate)[0];
    });
  }

  List<String> _getOptionsBasedOnDate(DateTime selectedDate) {
    List<String> dayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    String dayOfWeek = dayNames[selectedDate.weekday];
    List<String> options = List<String>.from(_dayOptions);
    options[1] += dayOfWeek;
    options[2] += 'first $dayOfWeek';

    return options;
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
    String result = '';

    if (extractedDays.length == 1) {
      result = '$prefix ${extractedDays[0]}';
    } else {
      result =
          '$prefix ${extractedDays.sublist(0, extractedDays.length - 1).join(', ')} and ${extractedDays.last}';
    }

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
                          textInputType: TextInputType.text,
                          hintText: "Car Plate Number",
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
                          hintText: "Car Model Year",
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
                            itemExtent: 30,
                            onDateTimeChanged: (index) {
                              setState(() {
                                _selectedTime = index;
                              });
                              formattedDate =
                                  '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                            child:
                                Text("Set Day", style: AppFonts.normalBlack18)),
                        const SizedBox(height: 20),
                        CalendarWidget(
                          initialDate: _selectedDate,
                          onDateSelected: _onDateSelected,
                        ),
                        const SizedBox(height: 20),
                        const Center(
                            child: Text("Set Frequency",
                                style: AppFonts.normalBlack18)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _selectedOption == "Custom"
                              ? TableCalendar(
                                  availableGestures: AvailableGestures.none,
                                  calendarStyle: const CalendarStyle(
                                      markerSize: 20,
                                      todayDecoration: BoxDecoration(
                                        color: AppColors.callToActionColor,
                                        shape: BoxShape.circle,
                                      )),
                                  headerVisible: false,
                                  focusedDay: _selectedDate,
                                  firstDay: DateTime(DateTime.now().year,
                                      DateTime.now().month - 1),
                                  lastDay: DateTime(DateTime.now().year,
                                      DateTime.now().month + 1),
                                  calendarFormat: CalendarFormat.month,
                                  selectedDayPredicate: (day) {
                                    return _selectedDates.contains(day);
                                  },
                                  onDaySelected: (selectedDay, focusedDay) {
                                    // Check if selectedDay is not before the current date and not in the next month
                                    if (!selectedDay.isBefore(DateTime.now()) &&
                                        selectedDay.month ==
                                            DateTime.now().month) {
                                      setState(() {
                                        if (_selectedDates
                                            .contains(selectedDay)) {
                                          _selectedDates.remove(selectedDay);
                                        } else {
                                          _selectedDates.add(selectedDay);
                                        }
                                      });
                                      print(_selectedDates);
                                    }
                                  },
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedOption ??
                                        _getOptionsBasedOnDate(_selectedDate)[
                                            0], // Use _selectedOption if not null, otherwise use the default value
                                    items: _getOptionsBasedOnDate(_selectedDate)
                                        .map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ),
                        ),
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
                              onChanged: (value) {},
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

class CalendarWidget extends StatelessWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CalendarWidget(
      {super.key, required this.initialDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.callToActionColor,
            minimumSize: const Size(150, 40)),
        onPressed: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != initialDate) {
            onDateSelected(pickedDate);
            CommonData.showCustomSnackbar(context, "Day Selection updated");
          }
        },
        child: const Text(
          'Select Day',
          style: AppFonts.normalWhite13,
        ),
      ),
    );
  }
}
