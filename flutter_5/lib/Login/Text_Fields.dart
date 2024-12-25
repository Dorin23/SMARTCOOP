import 'package:flutter/material.dart';

class Text_Fields extends StatelessWidget {
  final controller;
  final String text;
  final bool obscuretext;
  final Widget? prefixIcon;

   Text_Fields({
    super.key,
    required this.controller,
    required this.text,
    required this.obscuretext,
    this.prefixIcon,
  
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 8), 
            ),
          ],
        ),
            child: TextField(
              controller: controller,
              obscureText: obscuretext,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 157, 156, 156)),
                  borderRadius: BorderRadius.circular(25),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              
                hintText:text,
                prefixIcon: prefixIcon,
                 
              ),
            ),
          )
    );
  }
}