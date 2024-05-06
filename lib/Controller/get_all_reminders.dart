import 'dart:io';

import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Views/Pages/Home%20Pages/sweep_schedule_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetAllReminders {
  Future<void> addNewReminder(BuildContext context, bool byTap) async {
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();

      Response response = await dio.get(
        AppApi.getAllRemindersUrl,
      );
      if (response.statusCode == 200 && context.mounted) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
        ParkingRemindersSingleton().tickets.clear();
        final data = response.data["data"];
        for (var jsonObject in data) {
          ParkingReminders ticket = ParkingReminders.fromJson(jsonObject);
          ParkingRemindersSingleton().addTicket(ticket);
        }
        if (byTap) {
          if (Platform.isAndroid) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SweepSchedulePage(),
            ));
          } else {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => const SweepSchedulePage(),
            ));
          }
        }
      } else {
        if (context.mounted) {
          CommonData.sshowDialog("Error", response.data['message'], context);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        if (context.mounted) {
          Provider.of<LoadingManagemet>(context, listen: false)
              .changeApiHittingBehaviourToFalse();

          CommonData.showCustomSnackbar(context, "No internet connection");
        }
      } else {
        if (context.mounted) {
          Provider.of<LoadingManagemet>(context, listen: false)
              .changeApiHittingBehaviourToFalse();

          if (context.mounted) {
            CommonData.sshowDialog(
                'Error', e.response!.data['message'], context);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
      }

      if (context.mounted) {
        CommonData.sshowDialog(
            "Unexpected behaviour",
            "An un-expected error accourd restarting your app might resolve this issue",
            context);
      }
      rethrow;
    }
    if (context.mounted) {
      Provider.of<LoadingManagemet>(context, listen: false)
          .changeApiHittingBehaviourToFalse();
    }
  }
}
