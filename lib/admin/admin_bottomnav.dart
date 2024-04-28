
import 'package:campuscrave/admin/admin_dashboard.dart';
import 'package:campuscrave/admin/admin_order.dart';
import 'package:campuscrave/admin/display.dart';
import 'package:campuscrave/admin/home_admin.dart';
import 'package:campuscrave/pages/home.dart';
import 'package:campuscrave/pages/order.dart';
import 'package:campuscrave/pages/profile.dart';
import 'package:campuscrave/pages/wallet.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';



class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomeAdmin adminHome;
  late AdminDashboard profile;
  late AdminOrderPage order;


  @override
  void initState() {
    adminHome = HomeAdmin();
    order = AdminOrderPage();
    profile = AdminDashboard();
   
    pages = [adminHome, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items:const  [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.list_alt_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
            ),
          
          ]),
      body: pages[currentTabIndex],
    );
  }
}
