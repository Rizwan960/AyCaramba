import 'dart:developer';

import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class VerifyReferalCodePage extends StatefulWidget {
  const VerifyReferalCodePage({super.key});

  @override
  State<VerifyReferalCodePage> createState() => _VerifyReferalCodePageState();
}

class _VerifyReferalCodePageState extends State<VerifyReferalCodePage>
    with WidgetsBindingObserver {
  final key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isKeyboardVisible = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardVisible =
        WidgetsBinding.instance.window.viewInsets.bottom > 0;
    setState(() {
      _isKeyboardVisible = keyboardVisible;
    });
  }

  Future<void> verifyRefralCode(String code) async {
    final isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    key.currentState!.save();
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();
      Map<String, dynamic> data = {"code": code};
      Response response = await dio.post(AppApi.verifyRefralCode, data: data);
      if (response.statusCode == 200) {
        log(response.data.toString());
        CommonData.showCustomSnackbar(context, response.data["message"]);
        Navigator.of(context).pop();
      } else {
        if (mounted) {
          CommonData.sshowDialog("Error", response.data['message'], context);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        if (mounted) {
          Provider.of<LoadingManagemet>(context, listen: false)
              .changeApiHittingBehaviourToFalse();

          CommonData.showCustomSnackbar(context, "No internet connection");
        }
      } else {
        if (mounted) {
          Provider.of<LoadingManagemet>(context, listen: false)
              .changeApiHittingBehaviourToFalse();

          if (mounted) {
            CommonData.sshowDialog(
                'Error', e.response!.data['message'], context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
      }

      if (mounted) {
        CommonData.sshowDialog(
            "Unexpected behaviour",
            "An un-expected error accourd restarting your app might resolve this issue",
            context);
      }
      rethrow;
    }
    if (mounted) {
      Provider.of<LoadingManagemet>(context, listen: false)
          .changeApiHittingBehaviourToFalse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isKeyboardVisible ? 140 : 250,
                child: SvgPicture.asset(
                  "Assets/Svg/verify_referral.svg",
                ),
              ),
              const SizedBox(height: 20),
              const Text("Enter your code below", style: AppFonts.normalGrey15),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: Colors.black,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                controller: emailController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "field should not be empty";
                  }
                  return null;
                },
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  fillColor: AppColors.whiteColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: "Enter code here",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.callToActionColor,
                    minimumSize: const Size.fromHeight(55)),
                onPressed: () => verifyRefralCode(emailController.text),
                child: const Text(
                  "Verify",
                  style: AppFonts.normalWhite18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
