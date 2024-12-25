import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyRadiobutton extends StatelessWidget {
  final String title;
  final int value;
  final int? groupValue;
  final Function(int?) onChanged;
  final Color activeColor;
  const MyRadiobutton({
    super.key,
    required this.activeColor,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    required this.value,
    });

 @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.black)),
          leading: Radio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ),
      ),
    );
  }
}