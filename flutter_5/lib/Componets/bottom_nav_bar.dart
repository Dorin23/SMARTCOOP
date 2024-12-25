import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final Function(int)? onTabChange;
  final int selectedIndex;

  MyBottomNavBar({Key? key, required this.onTabChange, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1))],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: GNav(
        rippleColor: Colors.grey[300]!, 
        hoverColor: Colors.grey[100]!, 
        gap: 8, 
        activeColor: Colors.blue, 
        iconSize: 30, 
        tabBackgroundColor: Colors.blue.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), 
        duration: Duration(milliseconds: 400), 
        tabMargin: EdgeInsets.all(5), 
        color: Colors.black, 
        tabs: [
          GButton(
            icon: Icons.control_camera,
            text: 'Control',
          ),
          GButton(
            icon: Icons.visibility,
            text: 'Monitoring',
          ),
        ],
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}
