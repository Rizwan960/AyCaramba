import 'package:ay_caramba/Model/notification_model.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetAllNotifications {
  Future<void> getAllNotifications(BuildContext context) async {
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();

      Response response = await dio.get(
        AppApi.getAllNotifications,
      );
      if (response.statusCode == 200 && context.mounted) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
        NotificationModel().parseJson(response.data);
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
