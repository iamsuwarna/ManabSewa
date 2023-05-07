import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_screen/ngo_bottombar/homescreen_ngo.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_screen/ngo_completed_donation.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_screen/view_ngodonations.dart';
import 'package:manav_sewa/FrontEnd/constants/about_user.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/completeddonation.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/viewpending.dart';
import 'package:provider/provider.dart';
import '../screens/homescreen.dart/HomeScreen.dart';
import 'globalvariables.dart';

class NGOBottomBar extends StatefulWidget {
  //static const String routeName = '/actual-home';
  const NGOBottomBar({Key? key}) : super(key: key);

  @override
  State<NGOBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<NGOBottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const HomeScreenNGO(),
    const ViewNGODonations(),
    NGOCompletedDonation(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ngo = Provider.of<NGOProvider>(context).ngo;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          //see donations
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.help),
            ),
            label: '',
          ),
          // ACCOUNT
          // BottomNavigationBarItem(
          //   icon: Container(
          //     width: bottomBarWidth,
          //     decoration: BoxDecoration(
          //       border: Border(
          //         top: BorderSide(
          //           color: _page == 2
          //               ? GlobalVariables.selectedNavBarColor
          //               : GlobalVariables.backgroundColor,
          //           width: bottomBarBorderWidth,
          //         ),
          //       ),
          //     ),
          //     child: const Icon(Icons.done_all_outlined),
          //   ),
          //   label: '',
          // ),
          // Completed donations
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.person),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
