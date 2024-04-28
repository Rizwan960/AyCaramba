import 'package:shared_preferences/shared_preferences.dart';

class AppSharefPrefHelper {
  static setUserTocker(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserToken", token);
    } catch (e) {
      rethrow;
    }
  }

  static setUserDetail(
    String name,
    String email,
    String phone,
    String city,
    String state,
    String code,
    int isSubscribed,
    int isWin,
    int isCodeValid,
    String photo,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserName", name);
      await prefs.setString("UserEmail", email);
      await prefs.setString("UserPhone", phone);
      await prefs.setString("UserCity", city);
      await prefs.setString("UserState", state);
      await prefs.setString("UserCode", code);
      await prefs.setInt("isSubscribed", isSubscribed);
      await prefs.setInt("isWin", isWin);
      await prefs.setInt("isCodeValid", isCodeValid);
      await prefs.setString("UserPhoto", photo);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> getUserNameAndEmail() async {
    List<String> data = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final name = prefs.getString("UserName") ?? "";
      final email = prefs.getString("UserEmail") ?? "";
      final userPhone = prefs.getString("UserPhone") ?? "";
      final userCity = prefs.getString("UserCity") ?? "";
      final userState = prefs.getString("UserState") ?? "";
      final userCode = prefs.getString("UserCode") ?? "";
      final isUserSubscribed = prefs.getInt("isSubscribed") ?? 0;
      final isWin = prefs.getInt("isWin") ?? 0;
      final isCodeValid = prefs.getInt("isCodeValid") ?? 0;
      final userPhoto = prefs.getString("UserPhoto") ?? "";
      data.add(name);
      data.add(email);
      data.add(userPhone);
      data.add(userCity);
      data.add(userState);
      data.add(userCode);
      data.add(isUserSubscribed.toString());
      data.add(isWin.toString());
      data.add(isCodeValid.toString());
      data.add(userPhoto);
    } catch (e) {
      rethrow;
    }
    return data;
  }

  static Future<bool> getUserSubcriptionStauts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('isSubscribed') == 0 ? false : true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> setUserName(String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString('UserName', name);
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> setUserEmail(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString('UserEmail', email);
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getUserToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('UserToken') ?? "";
    } catch (e) {
      rethrow;
    }
  }
}
