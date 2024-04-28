import 'dart:io';

import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:ay_caramba/Views/Auth/reset_password_page.dart';
import 'package:ay_caramba/Widgets/Profile%20Widgets/personal_detail_tile_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSeetingsPage extends StatefulWidget {
  const ProfileSeetingsPage({super.key});

  @override
  State<ProfileSeetingsPage> createState() => _ProfileSeetingsPageState();
}

class _ProfileSeetingsPageState extends State<ProfileSeetingsPage> {
  final updateController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  final key = GlobalKey<FormState>();
  void _showEditOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            "What you want to update?",
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                updateController.text = CommonData.userName;
                showDialogForUpdate("Name");
              },
              child: const Text(
                'Name',
                style: AppFonts.normalBlack13,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Handle email editing
                Navigator.pop(context);
                updateController.text = CommonData.userEmail;

                showDialogForUpdate("Email");
              },
              child: const Text(
                'Email',
                style: AppFonts.normalBlack13,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void _showEditOptionsForAndroid(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text("What you want to update?"),
            ListTile(
              title: const Text('Name'),
              onTap: () {
                Navigator.pop(context);
                updateController.text = CommonData.userName;

                showDialogForUpdate("Name");
              },
            ),
            ListTile(
              title: const Text('Email'),
              onTap: () {
                Navigator.pop(context);
                updateController.text = CommonData.userEmail;
                showDialogForUpdate("Email");
              },
            ),
            ListTile(
              title: const Center(
                  child: Text('Cancel', style: TextStyle(color: Colors.red))),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20)
          ],
        );
      },
    );
  }

  void showDialogForUpdate(String title) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog.adaptive(
            title: Center(
                child: Text(
              "Update your $title",
              style: AppFonts.normalBlack15,
            )),
            content: Form(
              key: key,
              child: TextFormField(
                cursorColor: Colors.black,
                controller: updateController,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                validator: title == "Name"
                    ? (value) {
                        if (value!.isEmpty) {
                          return "field should not be empty";
                        }
                        if (value.length < 3) {
                          return "should be greater then 3 characters";
                        }
                        return null;
                      }
                    : (value) {
                        if (value!.isEmpty) {
                          return "field should not be empty";
                        }
                        if (!value.isEmail()) {
                          return "invalid email";
                        }
                        return null;
                      },
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: AppColors.blackColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.backgroundColor),
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.callToActionColor,
                    minimumSize: const Size.fromHeight(45)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  logout(title.toLowerCase(), updateController.text);
                },
                child: const Text(
                  "Update",
                  style: AppFonts.normalWhite18,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> logout(String keyy, String value) async {
    final isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    key.currentState!.save();
    Navigator.of(context).pop();
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();
      Map<String, dynamic> data = {keyy: value};
      Response response = await dio.post(AppApi.updateUserUrl, data: data);
      if (response.statusCode == 200) {
        if (keyy == "name") {
          AppSharefPrefHelper.setUserName(value);
          CommonData.userName = value;
        } else {
          AppSharefPrefHelper.setUserEmail(value);
          CommonData.userEmail = value;
        }
        setState(() {});
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

  Future<void> deleteAccount() async {
    Provider.of<LoadingManagemet>(context, listen: false)
        .changeApiHittingBehaviourToTrue();
    try {
      Dio dio = await CommonData.createDioWithAuthHeader();
      Map<String, dynamic> data = {"email": CommonData.userEmail};
      Response response = await dio.post(AppApi.deleteAccount, data: data);
      if (response.statusCode == 200) {
        Provider.of<LoadingManagemet>(context, listen: false)
            .changeApiHittingBehaviourToFalse();
        final pref = await SharedPreferences.getInstance();
        pref.clear();
        if (Platform.isAndroid) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false);
        }
        CommonData.showCustomSnackbar(context, "Account deleted successfully");
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
                  "Profile Settings",
                  style: AppFonts.normalBlack21,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Personal Details",
                            style: TextStyle(
                                color: AppColors.yellowTextColor, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  _showEditOptionsForAndroid(context);
                                } else {
                                  _showEditOptions(context);
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.pencil,
                                color: AppColors.callToActionColor,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      PersonalDetailTileWidget(
                        showLock: false,
                        title: CommonData.userName,
                        icon: const Icon(
                          CupertinoIcons.person_alt_circle,
                          color: AppColors.yellowTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PersonalDetailTileWidget(
                        showLock: false,
                        title: CommonData.userEmail,
                        icon: const Icon(
                          CupertinoIcons.mail_solid,
                          color: AppColors.yellowTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PersonalDetailTileWidget(
                        showLock: true,
                        title: CommonData.userPhone,
                        icon: const Icon(
                          CupertinoIcons.phone_circle_fill,
                          color: AppColors.yellowTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(
                                color: AppColors.yellowTextColor, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordPage(),
                                  ));
                                } else {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordPage(),
                                  ));
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.pencil,
                                color: AppColors.callToActionColor,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      PersonalDetailTileWidget(
                        title: "*********",
                        showLock: false,
                        icon: const Icon(
                          CupertinoIcons.lock_circle_fill,
                          color: AppColors.yellowTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red.shade200,
                  ),
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      "Delete Confirmation",
                                      style: AppFonts.boldBlack18,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      "Once you delete your account,all of your information lost forever.We will not be able to restore your account, Are your sure you want to proceed?",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  RichText(
                                    text: const TextSpan(
                                      text: "Confirm by typing ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                      children: [
                                        TextSpan(
                                          text: "delete ",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 15),
                                        ),
                                        TextSpan(
                                          text: "below",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Form(
                                      key: key,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              onEditingComplete: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              onTapOutside: (event) =>
                                                  FocusScope.of(context)
                                                      .unfocus(),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "";
                                                }

                                                return null;
                                              },
                                              cursorColor: Colors.black,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: confirmController,
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color:
                                                        Colors.grey.shade500),
                                                hintText: 'type delete',
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.grey)),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            if (confirmController.text ==
                                                "delete") {
                                              Navigator.of(ctx).pop();
                                              deleteAccount();
                                            }
                                          },
                                          child: const Text("Delete",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((value) {
                        setState(() {
                          confirmController.clear();
                        });
                      });
                    },
                    title: const Text(
                      "Delete Account",
                      style: AppFonts.normalBlack13,
                    ),
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    trailing: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.red,
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
