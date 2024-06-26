import 'package:flutter/material.dart';

class ParkingReminders {
  final int id;
  final int userId;
  final String carName;
  final String carModel;
  final String carNumber;
  final String color;
  final String street;
  final String ticketFees;
  List<String>? days;
  final bool isRepeat;
  final String time;
  final String reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParkingReminders({
    required this.id,
    required this.userId,
    required this.carName,
    required this.carModel,
    required this.carNumber,
    required this.color,
    required this.street,
    required this.ticketFees,
    this.days,
    required this.isRepeat,
    required this.time,
    required this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParkingReminders.fromJson(Map<String, dynamic> json) {
    List<String>? extractDays(Map<String, dynamic> json) {
      if (json['days']['is_weekly'] != null) {
        return List<String>.from(json['days']['is_weekly']);
      } else if (json['days']['is_first_week'] != null) {
        return List<String>.from(json['days']['is_first_week']);
      } else if (json['days']['is_second_week'] != null) {
        return List<String>.from(json['days']['is_second_week']);
      } else if (json['days']['is_third_week'] != null) {
        return List<String>.from(json['days']['is_third_week']);
      } else if (json['days']['is_fourth_week'] != null) {
        return List<String>.from(json['days']['is_fourth_week']);
      } else if (json['days']['is_fifth_week'] != null) {
        return List<String>.from(json['days']['is_fifth_week']);
      } else if (json['days']['is_custom'] != null) {
        return List<String>.from(json['days']['is_custom']);
      }
      return null;
    }

    return ParkingReminders(
      id: json['id'],
      userId: json['user_id'],
      carName: json['car_name'],
      carModel: json['car_model'],
      carNumber: json['car_number'],
      color: json['color'],
      street: json['street'],
      ticketFees: json['ticket_fees'],
      days: extractDays(json),
      isRepeat: json['is_repeat'] == 1,
      time: json['time'],
      reminderTime: json['reminder_time'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ParkingRemindersSingleton extends ChangeNotifier {
  static final ParkingRemindersSingleton _instance =
      ParkingRemindersSingleton._internal();

  factory ParkingRemindersSingleton() {
    return _instance;
  }

  ParkingRemindersSingleton._internal();

  final List<ParkingReminders> _tickets = [];

  List<ParkingReminders> get tickets => _tickets;

  void addTicket(ParkingReminders ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }

  Future<void> removeReminder(int id) async {
    _tickets.removeWhere((ticket) => ticket.id == id);
    notifyListeners(); // Notify listeners after removing a reminder
  }
}
