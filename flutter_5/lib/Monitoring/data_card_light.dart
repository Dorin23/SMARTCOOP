import "package:flutter/material.dart";

class LightCard extends StatelessWidget {
  final double luxValue;

  const LightCard({
    super.key,
    required this.luxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const Text(
              'Light Intensity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              '${luxValue.toStringAsFixed(2)} Lux',
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
