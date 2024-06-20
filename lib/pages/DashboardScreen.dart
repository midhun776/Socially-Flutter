import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:socially/pages/HomeScreen.dart';
import 'package:socially/pages/ProfileScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var _selectedIndex = 0;

  final _pages = [
    const HomeScreen(),
    const ProfileScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        backgroundColor: Color.fromARGB(255, 226, 231, 222),
          color: Color.fromARGB(255, 160, 169, 140),
          activeColor: Color.fromARGB(255, 83, 115, 15),
          tabBackgroundColor: Color.fromARGB(252, 251, 255, 233),
          gap: 5,
          onTabChange: (index) {
            _selectedIndex = index;
            setState(() {});
          },
          tabs: const [
              GButton(icon: Icons.home_filled, text: "Home"),
              GButton(icon: Icons.map, text: "Find"),
              GButton(icon: Icons.group, text: "Community"),
              GButton(icon: Icons.person, text: "Profile"),
      ]),
    );
  }
}
