import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_5/Control/control_button.dart';
import 'package:flutter_5/Control/eadio_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MotorControlPage extends StatefulWidget {
  @override
  _MotorControlPageState createState() => _MotorControlPageState();
}

class _MotorControlPageState extends State<MotorControlPage> {
  final DatabaseReference database = FirebaseDatabase.instance.reference();
  bool doorIsClosed = false;
  bool doorIsOpened = false;
  int? selectedButton;

  @override
  void initState() {
    super.initState();
    loadSelectedRadio();
    database.child("motorControl").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        doorIsClosed = data['doorIsClosed'] ?? false;
        doorIsOpened = data['doorIsOpened'] ?? false;
      });
    });
  }

  void loadSelectedRadio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int savedRadio = prefs.getInt('selectedRadioButton') ?? 1;  
    setState(() {
      selectedButton = savedRadio;
    });
  }

  void selectedRadioButton(int? val) {
    if (val != null) {
      setState(() {
        selectedButton = val;
      });
      saveSelectedRadioButton(val);

      if(val == 1){
        updateDirection("stop", doorIsClosed, doorIsOpened);
      }
    }
  }

  void saveSelectedRadioButton(int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedRadioButton', val);
  }

  String get doorStatus {
    if (doorIsClosed) {
      return "The door is closed now.";
    } else if (doorIsOpened) {
      return "The door is open now.";
    } else {
      return "Status unknown.";
    }
  }

  void updateDirection(String direction, bool close, bool open) {
    database.child("motorControl").update({
      'direction': direction,
      'doorIsClosed': close,
      'doorIsOpened': open,
    });
  }


  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 55, 67, 74),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRadioButtons(),
              SizedBox(height: 30),
              _buildControlButtons(),
              SizedBox(height: 40),
              Text(doorStatus, style: TextStyle(fontSize: 20, color: Colors.cyan[300], fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      children: [
        MyRadiobutton(
          activeColor: Colors.red,
          groupValue: selectedButton,
          onChanged: selectedRadioButton,
          title: 'Automatic Control',
          value: 1,
        ),
        MyRadiobutton(
          activeColor: Colors.blue,
          groupValue: selectedButton,
          onChanged: selectedRadioButton,
          title: 'Manual Control',
          value: 2,
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyCustomButton(
          color: const Color.fromARGB(255, 243, 2, 2),
          direction: doorIsOpened && selectedButton != 1,
          text: 'Close',
          onTap: (doorIsOpened && selectedButton != 1) ? () => updateDirection("forward", true, false) : null,
        ),
        MyCustomButton(
          color: Color.fromARGB(255, 13, 161, 3),
          direction: doorIsClosed && selectedButton != 1,
          text: 'Open',
          onTap: (doorIsClosed && selectedButton != 1) ? () => updateDirection("backward", false, true) : null,
        ),
      ],
    );
  }
}
