import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareReferralCodePage extends StatelessWidget {
  const ShareReferralCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 20),
          SvgPicture.asset("Assets/Svg/share_referral.svg", height: 250),
          const SizedBox(height: 30),
          const Text("Your Code", style: AppFonts.normalGrey15),
          const SizedBox(height: 20),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                CommonData.userCode,
                style: AppFonts.normalBlack15,
              ),
              trailing: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: CommonData.userCode));
                  CommonData.showCustomSnackbar(
                      context, "Coppied to clipboard");
                },
                child: const Icon(
                  Icons.copy,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final subject = Uri.encodeComponent("Ay Caramba Refral Code");
                  final body = Uri.encodeComponent(
                      "Hey there, We're thrilled to share an exclusive referral code with you! Share the love and invite your friends to join us. Your unique code is:${CommonData.userCode} Spread the word and enjoy the perks! Best regards,");

                  Uri mail = Uri.parse("mailto:?subject=$subject&body=$body");
                  if (await canLaunchUrl(mail)) {
                    await launchUrl(mail);
                  } else {
                    throw 'Could not launch email';
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.mail),
                      Text(
                        "Email",
                        style: AppFonts.normalBlack12,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  var uri =
                      "sms:?body=Hey there, We're thrilled to share an exclusive referral code with you! Share the love and invite your friends to join us. Your unique code is:${CommonData.userCode} Spread the word and enjoy the perks! Best regards,";
                  if (await canLaunch(uri)) {
                    await launch(uri);
                  } else {
                    throw 'Could not launch $uri';
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.bubble_left),
                      Text(
                        "Text",
                        style: AppFonts.normalBlack12,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  await Share.share(
                      "Hey there, We're thrilled to share an exclusive referral code with you! Share the love and invite your friends to join us. Your unique code is:${CommonData.userCode} Spread the word and enjoy the perks! Best regards,");
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_horiz),
                      Text(
                        "More",
                        style: AppFonts.normalBlack12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
