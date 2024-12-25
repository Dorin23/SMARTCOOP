import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_5/Componets/bottom_nav_bar.dart';
import 'package:flutter_5/Control/MotorControlPage.dart';
import 'package:flutter_5/Monitoring/MonitoringPage.dart';
import 'package:flutter_5/about_page.dart';
import 'package:flutter_5/customer_page.dart';
import 'package:flutter_5/drawer.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State
{
   int selectedIndex = 0;

void navigateBottomBar(int index) {
   setState(() {
   selectedIndex = index;
});
}

final List<Widget> pages = [
     MotorControlPage(),
     MonitorPage(),
];

void signOut() {
FirebaseAuth.instance.signOut();
}

@override
Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Colors.grey.shade200,
     bottomNavigationBar: MyBottomNavBar(
      selectedIndex: selectedIndex,
      onTabChange: (index) => navigateBottomBar(index),
     ),
     appBar: AppBar(
      backgroundColor: Colors.grey.shade200,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ), 
          onPressed: (){
            Scaffold.of(context).openDrawer();
          }),
      )
      
     ),
    drawer: CustomDrawer(
      onHomeTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
       onAboutTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage())),
       onCustomerTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerPage())),
       onLogoutTap: () => FirebaseAuth.instance.signOut(),
    ),
     body: pages[selectedIndex],
   );
}
}