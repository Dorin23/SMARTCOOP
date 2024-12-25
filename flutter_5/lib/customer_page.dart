import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_5/about_page.dart';
import 'package:flutter_5/drawer.dart';
import 'package:flutter_5/home_page.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
       appBar: AppBar(
         backgroundColor: Colors.black,
          title: Text("Customer Support", style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold)),  
        centerTitle: true,
          leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
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
    body:  Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Need Help?",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red,)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Our team is always ready to help you. Please contact us by phone or via email.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 30),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.phone, color:Colors.red, size:18), 
                  ),
                  TextSpan(
                    text: "+40 0769 938 091",
                    style:  TextStyle(
                      color:Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                
                  TextSpan(text: "\n"),
                  TextSpan(text: "\n"),
                  TextSpan(text: "\n"),
                  WidgetSpan(
                  child: Icon(Icons.email,color: Colors.red, size: 18)
                  ),
                  TextSpan(
                    text: "contact@smart-coop.com",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    )
                  )
              ],

            ) ,
          ),
        ],
      )
    ),
    );
  }
}