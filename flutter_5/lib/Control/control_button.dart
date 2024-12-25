import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyCustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool direction;
  final Color color;


  const MyCustomButton({
    super.key,
    required this.color,
    required this.direction,
    required this.text,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        
        duration: const Duration(milliseconds: 200),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 5.0,
            color: Colors.black
          ),
           gradient: LinearGradient(
            colors: direction ? [color, Colors.black] : [Colors.grey, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(4, 4),
          ),
          BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(-4, -4),  
            ),
        ]
        ),
        child: Center(
          child: Text(
            text,
            style:TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
      ),
    );
  }
}