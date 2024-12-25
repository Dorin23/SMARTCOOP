import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_5/Login/Text_Fields.dart';
import 'package:flutter_5/Login/auth_firebase.dart';
import 'package:flutter_5/Login/google_signIn.dart';
import 'package:flutter_5/Login/my_button.dart';


class LoginPage extends StatefulWidget{
  final Function()? onTap;
   LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final emailController = TextEditingController();

  final passwordController = TextEditingController();


  Future<void> signUser() async {

    showDialog(context: context, builder: (context){
          return Center(child: CircularProgressIndicator());
    });
  try{
       await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: emailController.text,
       password: passwordController.text
       );
  } on FirebaseAuthException catch (e){
    if(e.code == 'user-not-found'){
      print('Not email exist!');
    } else if(e.code == 'wrong-password'){
      print('Wrong password!');
    }
  }
       Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SizedBox(height: 50),

            
            Image.asset('lib/google/chicken.png',width: 130,height: 130,),

            SizedBox(height: 15),
            
          Text('Welcome back',style: TextStyle(color: Colors.grey[700],
          fontSize:30,
          fontWeight: FontWeight.bold,
          ),
          ),
           SizedBox(height: 8),

              
          Text('Enter your credential to login',style: TextStyle(color: Colors.grey[700],
          fontSize:15,
          
          ),
          ),

          SizedBox(height: 30),
            
          Text_Fields(
            controller: emailController,
            text: 'Email',
            obscuretext: false,
            prefixIcon: Icon(Icons.email),
          ),

          SizedBox(height: 10),
            
          Text_Fields(
            controller: passwordController,
            text: 'Password',
            obscuretext: true,
            prefixIcon: Icon(Icons.password),
          ),
          SizedBox(height: 10),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                
              ),
            ),
          
            
            SizedBox(height: 20),
            
            MyButton(
              onTap: signUser, text: 'Sign In',
            ),

            SizedBox(height: 25),
        
           
            Text('Or continue with'),
            SizedBox(height: 5),
            
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              googleButton(
                onTap: () => AuthFirebase().signInWithGoogle(),
                image: 'lib/google/google_logo.png'
                ),
            ],
          ),
          SizedBox(height: 5),
            

             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",style: TextStyle(color:Colors.grey[700])),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text('Sign Up',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
                  ),
             ],
            ),
          ],
        ),
      ),
    ),
      )
  );
}
}
