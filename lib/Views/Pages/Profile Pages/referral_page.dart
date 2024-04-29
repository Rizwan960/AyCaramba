import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Fonts/app_fonts.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/share_referal_code_page.dart';
import 'package:ay_caramba/Views/Pages/Profile%20Pages/verify_refral_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingManagemet>(
      builder: (context, value, _) {
        return DefaultTabController(
          length: 2,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: AppBar(
                  backgroundColor: AppColors.backgroundColor,
                  scrolledUnderElevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "Profile Settings",
                    style: AppFonts.normalBlack21,
                  ),
                  bottom: TabBar(
                    splashBorderRadius: BorderRadius.circular(10),
                    splashFactory:
                        InkSparkle.constantTurbulenceSeedSplashFactory,
                    indicatorColor: AppColors.callToActionColor,
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: const TextStyle(
                        color: AppColors.whiteColor, fontSize: 20),
                    labelColor: AppColors.callToActionColor,
                    labelStyle: const TextStyle(
                        color: AppColors.blackColor, fontSize: 20),
                    tabs: const [
                      Tab(
                          icon: Text(
                        "Invite",
                      )),
                      Tab(
                        icon: Text(
                          "Verify",
                        ),
                      ),
                    ],
                  ),
                ),
                body: const TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ShareReferralCodePage(),
                    VerifyReferalCodePage(),
                  ],
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
          ),
        );
      },
    );
  }
}
