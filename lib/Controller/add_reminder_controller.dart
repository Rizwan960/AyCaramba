import 'package:ay_caramba/Controller/get_all_reminders.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReminderController {
  Response? response;
  Future<void> addNewReminder(
      String carName,
      String carNumber,
      String carModel,
      String carColor,
      String carParkStreetAddress,
      String reminderTime,
      List<String> reminderDays,
      String remindBeforeTime,
      String ticketFees,
      BuildContext context,
      [String? id,
      bool? updateFunction]) async {
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();
      Map<String, dynamic> data = {
        "car_name": carName,
        "car_model": carModel,
        "car_number": carNumber,
        "color": carColor,
        "street": carParkStreetAddress,
        "ticket_fees": ticketFees,
        "days": reminderDays,
        "time": reminderTime,
        "reminder_time": remindBeforeTime == "12 hours"
            ? "720"
            : remindBeforeTime.split(" ").first,
        "is_repeat": 1,
        if (updateFunction == true) "reminder_id": id.toString()
      };
      if (updateFunction == true) {
        response = await dio.post(AppApi.editReminderUrl, data: data);
      } else {
        response = await dio.post(AppApi.addNewReminderUrl, data: data);
      }

      if (response!.statusCode == 200 && context.mounted) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
        await GetAllReminders().addNewReminder(context, false);
        CommonData.showCustomSnackbar(context, "Reminder Added Successfully");
        Navigator.of(context).pop();
      } else {
        if (context.mounted) {
          CommonData.sshowDialog("Error", response!.data['message'], context);
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
