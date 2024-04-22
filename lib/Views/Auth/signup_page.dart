import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Views/Auth/login_page.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
                      const SizedBox(height: 20),
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
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.words,
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
                      const SizedBox(height: 20),
                      Visibility(
                        visible: _index == 0 ? true : false,
                        child: FadeInLeft(
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                            },
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
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            selectorConfig: const SelectorConfig(
                              setSelectorButtonAsPrefixIcon: true,
                              leadingPadding: 10,
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              useBottomSheetSafeArea: true,
                            ),
                            ignoreBlank: false,
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
                            showStates: true,
                            showCities: true,
                            flagState: CountryFlag.ENABLE,
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
                            },
                            onStateChanged: (value) {
                              setState(() {
                                stateValue = value;
                              });
                            },
                            onCityChanged: (value) {
                              setState(() {
                                cityValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            onEditingComplete: () {},
                            keyboardType: TextInputType.emailAddress,
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
                      const SizedBox(height: 20),
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
                            onEditingComplete: () {},
                            keyboardType: TextInputType.emailAddress,
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
                          onPressed: () {
                            setState(() {
                              _index = 1;
                            });
                          },
                          child: const Text(
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
                                    ..onTap = () {
                                      if (Platform.isAndroid) {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ));
                                      } else {
                                        Navigator.of(context)
                                            .pushReplacement(CupertinoPageRoute(
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
