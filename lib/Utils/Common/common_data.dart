import 'dart:developer';
import 'dart:io';

import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonData {
  static String ongoinOrder = "";
  static String deviceId = "";
  static String? fcmTocken = "";
  static String userName = "";
  static String userEmail = "";
  static String userPhone = "";
  static String userPhoto = "";
  static String isUserSubscribed = "";
  static String isWin = "";
  static String isCodeValid = "";
  static String userCode = "";

  static Dio getDioInstance() {
    Dio dio = Dio();
    Map<String, dynamic> header = {
      'Device-Id': CommonData.deviceId,
      "Device-type": Platform.isAndroid ? "Android" : "IOS",
      'Accept': 'application/json',
    };
    dio.options.headers = header;
    return dio;
  }

  static Future<Dio> getDioInstanceForFcm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Dio dio = Dio();
    Map<String, dynamic> header = {
      'Accept': 'application/json',
      'Device-Id': CommonData.deviceId,
      "Device-type": Platform.isAndroid ? "Android" : "IOS",
      'Authorization': 'Bearer $token',
    };
    dio.options.headers = header;
    return dio;
  }

  static Future<Dio> createDioWithAuthHeader() async {
    String token = await AppSharefPrefHelper.getUserToken();
    log(token);
    Dio dio = Dio();
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return dio;
  }

  static Future<void> sshowDialog(
      String title, String message, BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Column(
            children: [
              const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(title),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.callToActionColor,
                  minimumSize: const Size.fromHeight(45)),
              child: const Text(
                'OK',
                style: AppFonts.normalWhite18,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showCustomSnackbar(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "#000000",
      webShowClose: true,
    );
  }

  static void showCustomSnackbarLong(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 60,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "#000000",
      webShowClose: true,
    );
  }

  static Future<Dio> createDioWithAuthHeaderForFcm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('UserToken')!;

    Dio dio = Dio();
    dio.options.headers = {
      'Device-Id': CommonData.deviceId,
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
          '',
    };

    return dio;
  }
}
