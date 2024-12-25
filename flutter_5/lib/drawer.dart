import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onAboutTap;
  final VoidCallback onLogoutTap;
  final VoidCallback onCustomerTap;

  CustomDrawer({
    required this.onHomeTap,
    required this.onAboutTap,
    required this.onLogoutTap,
    required this.onCustomerTap,
  });

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 0, 7, 4),
      child: Column(
        children: [
          DrawerHeader(child: Image.asset('lib/google/drawer.png', width: 100, height: 100)),
          buildDrawerItem(icon: Icons.home,title: 'Home', onTap: onHomeTap),
          buildDrawerItem(icon: Icons.info, title: 'About', onTap: onAboutTap),
          buildDrawerItem(icon: Icons.chat, title: 'Customer Support', onTap: onCustomerTap),
          SizedBox(height: 280),
          buildDrawerItem(icon: Icons.logout, title: 'Logout', onTap: onLogoutTap),
        ],
      ),
    );
  }

  Widget buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: Colors.green),
          title: Text(title,style: TextStyle(color:Colors.white)),
          trailing: const Icon(Icons.chevron_right,color: Colors.green,),
        ),
      ),
    );
  }
}
