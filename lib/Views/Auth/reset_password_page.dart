import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final key = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final currentPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool hidePassword3 = true;
  @override
  void dispose() {
    passwordFocusNode.dispose();
    currentPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    key.currentState!.save();
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();
      Map<String, dynamic> data = {
        "current_password": currentPasswordController.text,
        "new_password": passwordController.text
      };

      Response response = await dio.post(AppApi.resetPasswordUrl, data: data);
      if (response.statusCode == 200) {
        CommonData.showCustomSnackbar(context, "Password updated successfully");
        setState(() {
          currentPasswordController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        });
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
    return Consumer<LoadingManagemet>(
      builder: (context, value, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: AppBar(
                backgroundColor: AppColors.backgroundColor,
                scrolledUnderElevation: 0,
                title: const Text(
                  "Reset Password",
                  style: AppFonts.normalBlack21,
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
                        const SizedBox(height: 20),
                        const Text(
                          "Current Password",
                          style: TextStyle(
                            color: AppColors.yellowTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: hidePassword1,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          focusNode: currentPasswordFocusNode,
                          controller: currentPasswordController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "field should not be empty";
                            }
                            if (value.length < 8) {
                              return "minimum 8 character required";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword1 = !hidePassword1;
                                });
                              },
                              icon: hidePassword1
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: AppColors.blackColor)),
                            labelText: "Current Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: AppColors.backgroundColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "New Password",
                          style: TextStyle(
                            color: AppColors.yellowTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: hidePassword2,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(confirmPasswordFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "field should not be empty";
                            }
                            if (value.length < 8) {
                              return "minimum 8 character required";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword2 = !hidePassword2;
                                });
                              },
                              icon: hidePassword2
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: AppColors.blackColor)),
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: AppColors.backgroundColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: hidePassword3,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          focusNode: confirmPasswordFocusNode,
                          controller: confirmPasswordController,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "field should not be empty";
                            }
                            if (value.length < 8) {
                              return "minimum 8 character required";
                            }
                            if (!value.contains(passwordController.text)) {
                              return "password did not match";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword3 = !hidePassword3;
                                });
                              },
                              icon: hidePassword3
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: AppColors.blackColor)),
                            labelText: "Confirm Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: AppColors.backgroundColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.callToActionColor,
                              minimumSize: const Size.fromHeight(55)),
                          onPressed: () => resetPassword(),
                          child: const Text(
                            "Reset",
                            style: AppFonts.normalWhite18,
                          ),
                        ),
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
