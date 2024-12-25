import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DataCardActivationCount extends StatelessWidget {
  final String title;
  final String image;
  final String value;
  const DataCardActivationCount({
    super.key,
    required this.image,
    required this.value,
    required this.title
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        color: Color.fromARGB(255, 195, 197, 213),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        elevation: 15,
         child: Container(
          padding: EdgeInsets.all(20),
         width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              Text(
                title,
                style:const TextStyle(
                  color:Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(image),
                  
                  )
                ),
              ),
              SizedBox(height: 10),
              Flexible(
                child: Text(
                   value,
                   style:const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                   ),
                   textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}