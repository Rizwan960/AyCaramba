import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                focusNode: passwordFocusNode,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {},
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: AppColors.blackColor)),
                  labelText: "Current Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.backgroundColor),
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
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                focusNode: passwordFocusNode,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {},
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: AppColors.blackColor)),
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.backgroundColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: Colors.black,
                obscureText: hidePassword3,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                focusNode: confirmPasswordFocusNode,
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {},
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.words,
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: AppColors.blackColor)),
                  labelText: "Confirm Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.backgroundColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.callToActionColor,
                    minimumSize: const Size.fromHeight(55)),
                onPressed: () {},
                child: const Text(
                  "Reset",
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
