import 'package:flutter/material.dart';

class googleButton extends StatelessWidget {
  final String image;
  final VoidCallback? onTap;

  const googleButton({
    super.key,
    required this.image,
    required this.onTap,
    });

 @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Color.fromARGB(255, 182, 181, 181).withOpacity(0.5),
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
          color:Colors.white,
        ),
         child: Image.asset(image,height: 70),
          
      ),
    );
  }
}