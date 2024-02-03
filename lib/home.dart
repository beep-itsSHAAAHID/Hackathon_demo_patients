import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'Tabs/hom_tab.dart';
import 'core/color.dart';


class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavBar(
          actionButton: CurvedActionBar(
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: AppColors.textblue, shape: BoxShape.circle),
                child: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: AppColors.bgwhite,
                ),
              ),
              inActiveIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: AppColors.textblue, shape: BoxShape.circle),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 50,
                  color: AppColors.bgwhite,
                ),
              ),
              text: "Qr Scan"),
          activeColor: AppColors.bgwhite,
          navBarBackgroundColor: AppColors.textblue,
          inActiveColor: AppColors.bgwhite,
          appBarItems: [
            FABBottomAppBarItem(
                activeIcon: const Icon(
                  Icons.home,
                  color: AppColors.bgwhite,
                ),
                inActiveIcon: const Icon(
                  Icons.home,
                  color: AppColors.buttongrey,
                ),
                text: 'Home'),
            FABBottomAppBarItem(
                activeIcon: const Icon(
                  Icons.settings,
                  color: AppColors.bgwhite,
                ),
                inActiveIcon: const Icon(
                  Icons.settings,
                  color: AppColors.bgwhite,
                ),
                text: 'Settings'),
          ],
          bodyItems: [
            HomeTab(),
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.pinkAccent,
            )
          ],
          actionBarView: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}