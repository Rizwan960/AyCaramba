import 'package:flutter/cupertino.dart';

class NotificationModell extends ChangeNotifier {
  static final NotificationModell _instance = NotificationModell._internal();

  factory NotificationModell() {
    return _instance;
  }

  NotificationModell._internal();

  List<NotificationItem> data = [];

  void parseJson(Map<String, dynamic> jsonString) {
    final List<dynamic> notifications = jsonString['data'];
    data =
        notifications.map((json) => NotificationItem.fromJson(json)).toList();
  }

  void updateVerificationStatus(int id) {
    for (var notification in data) {
      if (notification.id == id) {
        notification.isVerified = true;
        notifyListeners();
        break;
      }
    }
    notifyListeners();
  }
}

class NotificationItem {
  final int id;
  final String carName;
  final String day;
  final String time;
  final String street;
  final int saveTicket;
  bool isVerified;

  NotificationItem({
    required this.id,
    required this.carName,
    required this.day,
    required this.time,
    required this.street,
    required this.saveTicket,
    required this.isVerified,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      carName: json['car_name'],
      day: json['day'],
      time: json['time'],
      street: json['street'],
      saveTicket: int.parse(json['save_ticket'].toString()),
      isVerified: json['is_verified'] == 1,
    );
  }
}
