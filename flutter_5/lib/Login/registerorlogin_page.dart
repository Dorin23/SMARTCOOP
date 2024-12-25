import 'package:flutter/material.dart';
import 'package:flutter_5/Login/LoginPage.dart';
import 'package:flutter_5/Login/register_page.dart';

class RegisterOrLoginPage extends StatefulWidget {
  const RegisterOrLoginPage({super.key});

  @override
  State<RegisterOrLoginPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterOrLoginPage> {

//initial vedem login page
  int indexPage = 0;


  void swichPage(){
    setState(() {
      indexPage= 1 - indexPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(indexPage == 0){
    return LoginPage(
      onTap: swichPage,
    );
  }else{
    return RegisterPage(onTap:swichPage);
  }
  }
}