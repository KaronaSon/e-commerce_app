import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../home_page/home.dart';
import '../settings/setting.dart';
import '../wishlist/wish_list.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          WishListScreen(),
          Setting(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            left: 20,
            right: 20,
            top: 10,
          ),
          child: GNav(
            onTabChange: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            tabBorderRadius: 15,
            curve: Curves.linearToEaseOut,
            duration: const Duration(milliseconds: 600),
            gap: 6,
            color: Colors.grey[800],
            activeColor: Colors.black,
            iconSize: 20,
            style: GnavStyle.google,
            tabBackgroundColor: Colors.blue.shade100,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            tabs: [
              GButton(
                icon: Icons.home,
                leading: currentIndex == 0
                    ? SvgPicture.asset(
                        "assets/home_solid.svg",
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        "assets/home 03.svg",
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite,
                leading: currentIndex == 1
                    ? SvgPicture.asset(
                        "assets/love_solid.svg",
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        "assets/love.svg",
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                text: 'Wishlist',
              ),
              GButton(
                icon: Icons.settings,
                leading: currentIndex == 2
                    ? SvgPicture.asset(
                        "assets/setting_solid.svg",
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        "assets/setting.svg",
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                text: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
