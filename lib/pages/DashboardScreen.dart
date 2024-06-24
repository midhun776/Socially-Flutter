import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/ChatInboxScreen.dart';
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
    const Chatinboxscreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar:
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () { setState(() {
                    _selectedIndex = 0;
                  }); },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.home, color: _selectedIndex == 0 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                        Text("Home",
                        style: TextStyle(fontSize: 10, color: _selectedIndex == 0 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                        overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () { setState(() {
                    _selectedIndex = 1;
                  }); },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.map, color: _selectedIndex == 1 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                        Text("Connect",
                          style: TextStyle(fontSize: 10, color: _selectedIndex == 1 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                          overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () { setState(() {
                    _selectedIndex = 2;
                  }); },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.notification_add, color: _selectedIndex == 2 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                        Text("Notification",
                          style: TextStyle(fontSize: 10, color: _selectedIndex == 2 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                          overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () { setState(() {
                    _selectedIndex = 3;
                  }); },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.person, color: _selectedIndex == 3 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                        Text("Profile",
                          style: TextStyle(fontSize: 10, color: _selectedIndex == 3 ? ColorResources.SelectedIconColor : ColorResources.UnselectedIconColor),
                          overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ),
              ]
            ),
          ),
      // GNav(
      //   backgroundColor: Color.fromARGB(255, 226, 231, 222),
      //     color: Color.fromARGB(255, 160, 169, 140),
      //     activeColor: Color.fromARGB(255, 83, 115, 15),
      //     tabBackgroundColor: Color.fromARGB(252, 251, 255, 233),
      //     gap: 5,
      //     onTabChange: (index) {
      //       _selectedIndex = index;
      //       setState(() {});
      //     },
      //     tabs: const [
      //         GButton(icon: Icons.home_filled, text: "Home"),
      //         GButton(icon: Icons.map, text: "Find"),
      //         GButton(icon: Icons.group, text: "Community"),
      //         GButton(icon: Icons.person, text: "Profile"),
      // ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {},
            child: Icon(Icons.add),
        elevation: 2.0,  // Adjust elevation as needed
        shape: CircleBorder(),
      )
    );
  }
}
