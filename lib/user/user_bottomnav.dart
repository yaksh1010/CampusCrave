import 'package:campuscrave/user/user_home.dart';
import 'package:campuscrave/user/user_cart.dart';
import 'package:campuscrave/user/user_profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;

  @override
  void initState() {
    homepage = Home();
    order = Order();
    profile = Profile();

    pages = [homepage, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions to make the UI responsive
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            height: screenHeight * 0.07, // Adjust the height based on the screen height
            backgroundColor: Colors.white,
            color: Colors.black,
            animationDuration: const Duration(milliseconds: 500),
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: [
              Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: screenWidth * 0.06, // Adjust icon size based on the screen width
              ),
              Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: screenWidth * 0.06, // Adjust icon size based on the screen width
              ),
              Icon(
                Icons.person_outline,
                color: Colors.white,
                size: screenWidth * 0.06, // Adjust icon size based on the screen width
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: pages[currentTabIndex],
          ),
        ));
  }
}
