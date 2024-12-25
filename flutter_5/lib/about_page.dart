import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_5/customer_page.dart';
import 'package:flutter_5/drawer.dart';
import 'package:flutter_5/home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
       appBar: AppBar(
         backgroundColor: Colors.black,
           title: Text("About", style: TextStyle(color: Colors.grey, fontSize: 15,fontWeight: FontWeight.bold)),  
           centerTitle: true,
          leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.grey,
          ), 
          onPressed: (){
            Scaffold.of(context).openDrawer();
          }),
      ),
       ),
    drawer: CustomDrawer(
       onHomeTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
       onAboutTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage())),
       onCustomerTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerPage())),
       onLogoutTap: () => FirebaseAuth.instance.signOut(),
    ),
    body:const SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             const Text(
                'This application is designed to allow automatic control and monitoring of your chicken coop door, ensuring the security and comfort of your chickens.',
                style: TextStyle(fontSize: 16,color: Colors.grey),
              ),
            const  SizedBox(height: 20),
             const ListTile(
                leading: Icon(Icons.settings,color: Colors.red,),
                title: Text('Main Features',style: TextStyle(color: Colors.red),),
                subtitle: Text(
                    'Automatic control,Manual control,Real-Time monitoring, Real-Time alerts',
                    style: TextStyle(color: Colors.grey),
              ),
             ),
             const ListTile(
                leading: Icon(Icons.smartphone,color: Colors.red,),
                title: Text('Technology used',
                style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(
                    'Light Sensor, WI-FI connectivity',style: TextStyle(color: Colors.grey),),
              ),
              ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.red),
                title: Text('Getting Started', style: TextStyle(color: Colors.red)),
                subtitle: Text('1. Connect the app to your Wi-Fi network.\n'
                               '2. Select the automatic or manual operation mode.\n'
                               '3. Monitor in real time for the safety of the chickens.\n'
                               '4. Security alerts will be triggered automatically.\n',
                               style: TextStyle(color:Colors.grey),
                               ),
                
              ),
              ListTile(
                leading: Icon(Icons.contact_mail,color:Colors.red),
                title: Text('Contact us',style:TextStyle(color:Colors.red)),
                subtitle: Text('Email: contact@smart-coop.com',style:TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              Text(
                'Aplication version: 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '©2024 Smart Coop SRL',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}