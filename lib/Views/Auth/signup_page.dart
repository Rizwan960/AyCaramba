import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:ay_caramba/Utils/Api/app_api.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Common/shared_pref.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:ay_caramba/Views/BottomNavBar/app_bottom_nav_bar.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:regexpattern/regexpattern.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _index = 0;
  final key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  bool loading = false;

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveLoginData() async {
    final isValid = key.currentState!.validate();
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
        'name': nameController.text,
        'phone': phoneController.text,
        'city': cityValue,
        'state': stateValue,
        // 'country': countryValue,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      };
      Response response = await dio.post(AppApi.registerUrl, data: data);
      if (response.statusCode == 200) {
        final data = response.data["data"];
        AppSharefPrefHelper.setUserTocker(response.data["token"]);
        AppSharefPrefHelper.setUserDetail(
          data["name"],
          data["email"],
          data["phone"],
          data["city"],
          data["state"],
          data["code"],
          data["is_subscribed"],
          data["is_win"],
          data["is_code_valid"],
          data["photo"] ?? "",
        );
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
          CommonData.showCustomSnackbar(context, "Register successfully");
        }
      } else {
        if (mounted) {
          CommonData.sshowDialog("Error", response.data['message'], context);
        }
      }
    } on DioException catch (e) {
      log(e.toString());
      log(e.type.toString());
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.callToActionColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(child: SvgPicture.asset("Assets/Svg/logo.svg", height: 100)),
            const SizedBox(height: 60),
            Container(
              height: size.height * 0.68,
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
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.yellowTextColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _index = 0;
                              });
                            },
                            child: Container(
                              height: 3,
                              width: size.width * 0.4,
                              color: AppColors.yellowTextColor,
                            ),
                          ),
                          Container(
                            height: 3,
                            width: size.width * 0.4,
                            color: _index == 0
                                ? const Color.fromARGB(255, 207, 206, 206)
                                : AppColors.yellowTextColor,
                          )
                        ],
                      ),
                      if (_index == 0) const SizedBox(height: 40),
                      Visibility(
                        visible: _index == 0 ? true : false,
                        child: FadeInLeft(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            focusNode: nameFocusNode,
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(emailFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "field should not be empty";
                              }
                              if (value.length < 3) {
                                return "should be greater then 3 characters";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: AppColors.blackColor)),
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: _index == 0 ? true : false,
                        child: FadeInLeft(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            focusNode: emailFocusNode,
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(phoneFocusNode);
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
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: _index == 0 ? true : false,
                        child: FadeInLeft(
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                            },
                            maxLength: 11,
                            inputDecoration: const InputDecoration(
                              labelText: "Phone",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: AppColors.blackColor)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "field should not be empty";
                              }
                              if (value.length < 12) {
                                return "invalid phone number";
                              }
                              return null;
                            },
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            selectorConfig: const SelectorConfig(
                              setSelectorButtonAsPrefixIcon: true,
                              leadingPadding: 10,
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              useBottomSheetSafeArea: true,
                            ),
                            ignoreBlank: true,
                            focusNode: phoneFocusNode,
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            textFieldController: phoneController,
                            formatInput: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _index != 0 ? true : false,
                        child: FadeInRight(
                          child: CSCPicker(
                            defaultCountry: CscCountry.United_States,
                            showStates: true,
                            showCities: true,
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            disabledDropdownDecoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: Colors.grey.shade300,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            selectedItemStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            dropdownHeadingStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            dropdownItemStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            dropdownDialogRadius: 10.0,
                            searchBarRadius: 10.0,
                            onCountryChanged: (value) {
                              setState(() {
                                countryValue = value;
                              });
                              log(countryValue!.trim());
                            },
                            onStateChanged: (value) {
                              setState(() {
                                stateValue = value;
                              });
                              log(stateValue.toString());
                            },
                            onCityChanged: (value) {
                              setState(() {
                                cityValue = value;
                              });
                              log(cityValue.toString());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: _index != 0 ? true : false,
                        child: FadeInRight(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            obscureText: hidePassword1,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            focusNode: passwordFocusNode,
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
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
                            textCapitalization: TextCapitalization.words,
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
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: _index != 0 ? true : false,
                        child: FadeInRight(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            obscureText: hidePassword2,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            focusNode: confirmPasswordFocusNode,
                            controller: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "field should not be empty";
                              }
                              if (value.length < 8) {
                                return "minimum 8 character required";
                              }
                              if (value.length < 8) {
                                return "should be greater then 8 characters";
                              }
                              if (!value.contains(passwordController.text)) {
                                return "Password did not match";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            textCapitalization: TextCapitalization.words,
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
                              labelText: "Confirm Password",
                              labelStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_index != 0) const SizedBox(height: 20),
                      FadeInUp(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.callToActionColor,
                              minimumSize: const Size.fromHeight(55)),
                          onPressed: _index == 1
                              ? () {
                                  if (passwordController.text.length < 8) {
                                    CommonData.sshowDialog(
                                        "Error",
                                        "Passowrd should be greater then 8 characters",
                                        context);
                                  }
                                  if (confirmPasswordController.text !=
                                      passwordController.text) {
                                    CommonData.sshowDialog("Error",
                                        "Passowrd did not match", context);
                                  } else {
                                    saveLoginData();
                                  }
                                }
                              : () {
                                  if (nameController.text.isNotEmpty &&
                                      emailController.text.isNotEmpty &&
                                      phoneController.text.isNotEmpty) {
                                    if (nameController.text.length < 3) {
                                      CommonData.sshowDialog(
                                          "Error",
                                          "Name should be greater then 3",
                                          context);
                                    } else if (!emailController.text
                                        .isEmail()) {
                                      CommonData.sshowDialog(
                                          "Error", "Invalid Email", context);
                                    } else if (phoneController.text.length <
                                        11) {
                                      CommonData.sshowDialog("Error",
                                          "Invalid Phone Number", context);
                                    } else {
                                      setState(() {
                                        _index = 1;
                                      });
                                    }
                                  } else {
                                    CommonData.sshowDialog(
                                        "Error",
                                        "Please enter required details",
                                        context);
                                  }
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
                              : _index == 1
                                  ? const Text(
                                      "Sign Up",
                                      style: AppFonts.normalWhite18,
                                    )
                                  : const Text(
                                      "Next",
                                      style: AppFonts.normalWhite18,
                                    ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account ? ",
                              style: AppFonts.normalGrey12,
                              children: [
                                TextSpan(
                                  text: "Log In",
                                  style: AppFonts.boldBlack12,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _index == 1
                                        ? null
                                        : () {
                                            if (Platform.isAndroid) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ));
                                            } else {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      CupertinoPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
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
            ),
          ],
        ),
      ),
    );
  }
}
