import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeNotifier extends ChangeNotifier {
  Locale? _currentLocale;

  Locale? get currentLocale => _currentLocale;

  void changeLocale(String languageCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("lan", languageCode);

    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  void getLocale(String languageCode) async {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}
