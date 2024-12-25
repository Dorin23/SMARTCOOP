import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_5/Login/LoginPage.dart';
import 'package:flutter_5/Login/registerorlogin_page.dart';
import 'package:flutter_5/home_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
            if(snapshot.hasData){
              return HomePage();
            }
           else {
            return RegisterOrLoginPage();
           }
        },
      ),
    );
  }
}