import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Views/BottomNavBar/BottomPages/home_page.dart';
import 'package:ay_caramba/Views/BottomNavBar/BottomPages/notification_page.dart';
import 'package:ay_caramba/Views/BottomNavBar/BottomPages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:simple_floating_bottom_nav_bar/floating_bottom_nav_bar.dart';
import 'package:simple_floating_bottom_nav_bar/floating_item.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  List<FloatingBottomNavItem> bottomNavItems = const [
    FloatingBottomNavItem(
      inactiveIcon: Icon(Icons.home, color: Colors.grey),
      activeIcon: Icon(Icons.home_filled, color: AppColors.callToActionColor),
      label: "Home",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(CupertinoIcons.bell, color: Colors.grey),
      activeIcon:
          Icon(CupertinoIcons.bell_fill, color: AppColors.callToActionColor),
      label: "Notification",
    ),
    FloatingBottomNavItem(
      inactiveIcon: Icon(CupertinoIcons.person, color: Colors.grey),
      activeIcon:
          Icon(CupertinoIcons.person_fill, color: AppColors.callToActionColor),
      label: "Person",
    ),
  ];

  List<Widget> pages = [
    const HomePage(),
    const NotificationPage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingManagemet>(
      builder: (context, value, _) {
        return Stack(
          children: [
            FloatingBottomNavBar(
              selectedLabelStyle:
                  const TextStyle(color: AppColors.callToActionColor),
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              pages: pages,
              items: bottomNavItems,
              initialPageIndex: 0,
              backgroundColor: const Color.fromARGB(255, 240, 205, 168),
              elevation: 0,
              radius: 20,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 65,
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
