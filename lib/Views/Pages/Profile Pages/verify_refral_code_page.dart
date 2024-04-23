import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerifyReferalCodePage extends StatefulWidget {
  const VerifyReferalCodePage({super.key});

  @override
  State<VerifyReferalCodePage> createState() => _VerifyReferalCodePageState();
}

class _VerifyReferalCodePageState extends State<VerifyReferalCodePage> {
  final key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: key,
        child: Column(
          children: [
            const SizedBox(height: 20),
            SvgPicture.asset("Assets/Svg/verify_referral.svg", height: 250),
            const SizedBox(height: 20),
            const Text("Enter your code below", style: AppFonts.normalGrey15),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: Colors.black,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              controller: emailController,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {},
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                fillColor: AppColors.whiteColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.blackColor)),
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
              onPressed: () {},
              child: const Text(
                "Verify",
                style: AppFonts.normalWhite18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
