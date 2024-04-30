import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:ay_caramba/Model/user_model.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Auth/forget_password_page.dart';
import 'package:ay_caramba/Views/Auth/signup_page.dart';
import 'package:ay_caramba/Views/BottomNavBar/app_bottom_nav_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:regexpattern/regexpattern.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool hidePassword = true;
  bool loading = false;
  User parseUser(dynamic jsonString) {
    return User.fromJson(jsonString);
  }

  Future<void> saveLoginData() async {
    bool isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    key.currentState!.save();
    setState(() {
      loading = true;
    });
    try {
      Dio dio = CommonData.getDioInstance();
      Map<String, dynamic> data = {
        'email': emailController.text,
        'password': passwordController.text,
      };
      Response response = await dio.post(AppApi.loginUrl, data: data);
      if (response.statusCode == 200) {
        log(response.data.toString());

        final data = response.data["data"];
        User user = parseUser(data);
        User currentUser = User.instance;
        await AppSharefPrefHelper.setUserTocker(response.data["token"]);
        await AppSharefPrefHelper.saveUser(currentUser);
        currentUser = await AppSharefPrefHelper.getUser();

        if (mounted) {
          if (Platform.isAndroid) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AppBottomNavBar(),
            ));
          } else {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (context) => const AppBottomNavBar(),
            ));
          }
          CommonData.showCustomSnackbar(context, "Login successfully");
        }
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
          setState(() {
            loading = false;
          });
          CommonData.showCustomSnackbar(context, "No internet connection");
        }
      } else {
        setState(() {
          loading = false;
        });
        if (mounted) {
          CommonData.sshowDialog('Error', e.response!.data['message'], context);
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (mounted) {
        CommonData.sshowDialog(
            "Unexpected behaviour",
            "An un-expected error accourd restarting your app might resolve this issue",
            context);
      }
      rethrow;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.callToActionColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(child: SvgPicture.asset("Assets/Svg/logo.svg", height: 140)),
            const SizedBox(height: 60),
            Container(
              height: size.height * 0.63,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(56),
                    topRight: Radius.circular(56)),
                color: AppColors.backgroundColor,
              ),
              child: Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.yellowTextColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInLeft(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          focusNode: emailFocusNode,
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "field should not be empty";
                            }
                            if (!value.isEmail()) {
                              return "invalid email";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: AppColors.blackColor)),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: AppColors.backgroundColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInLeft(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          obscureText: hidePassword,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            saveLoginData();
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
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: hidePassword
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
                      ),
                      FadeInRight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordPage(),
                                  ));
                                } else {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordPage(),
                                  ));
                                }
                              },
                              child: const Text(
                                "Forget Password?",
                                style: AppFonts.normalGrey15,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.callToActionColor,
                              minimumSize: const Size.fromHeight(55)),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            saveLoginData();
                          },
                          child: loading
                              ? Center(
                                  child: Platform.isAndroid
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        ),
                                )
                              : const Text(
                                  "Continue",
                                  style: AppFonts.normalWhite18,
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account ? ",
                              style: AppFonts.normalGrey12,
                              children: [
                                TextSpan(
                                  text: "Sign Up for free",
                                  style: AppFonts.boldBlack12,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (Platform.isAndroid) {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage(),
                                        ));
                                      } else {
                                        Navigator.of(context)
                                            .pushReplacement(CupertinoPageRoute(
                                          builder: (context) =>
                                              const SignUpPage(),
                                        ));
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
