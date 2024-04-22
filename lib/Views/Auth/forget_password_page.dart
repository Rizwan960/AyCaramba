import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with WidgetsBindingObserver {
  final form = GlobalKey<FormState>();
  bool _isKeyboardVisible = false;
  final emailController = TextEditingController();
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
      // Adjust the SVG image size based on keyboard visibility
      _isKeyboardVisible = keyboardVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isKeyboardVisible ? 15 : 25,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: _isKeyboardVisible ? 10 : 18),
                ),
              ),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isKeyboardVisible ? 140 : 400,
                  child: SvgPicture.asset(
                    "Assets/Svg/forget_password.svg",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "We'll send you an OTP to your email",
                  style: AppFonts.normalGrey15,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: form,
                child: TextFormField(
                  cursorColor: Colors.black,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus();
                  },
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: AppColors.blackColor)),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: AppColors.backgroundColor),
                    ),
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
                  "Continue",
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
