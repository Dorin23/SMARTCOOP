import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => isPressed = false);
  }

  void _onTapCancel() {
    setState(() => isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        transform: Transform.translate(
          offset: isPressed ? Offset(5, 5) : Offset(0, 0),
        ).transform,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color:  Color.fromARGB(115, 0, 0, 0),
              offset: isPressed ? Offset(0, 0) : Offset(8, 8),
              blurRadius: 10,
            ),
            BoxShadow(
              color:  Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
              offset: isPressed ? Offset(0, 0) : Offset(-4, -4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
