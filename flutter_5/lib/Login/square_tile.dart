import "package:flutter/material.dart";

class SquareTile extends StatelessWidget {
final Function()? onTap;
  final String image;
   SquareTile({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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