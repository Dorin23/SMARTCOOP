
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_5/Login/Text_Fields.dart';
import 'package:flutter_5/Login/auth_firebase.dart';
import 'package:flutter_5/Login/google_signIn.dart';
import 'package:flutter_5/Login/my_button.dart';

class RegisterPage extends StatelessWidget{
  final Function()? onTap;
   RegisterPage({super.key,required this.onTap});
  //Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  //sign user
Future<void> signUserUp(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
    if(passwordController.text == confirmPasswordController.text){
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    }else {
      showErrorMessage(context,"Password don't match");
    }
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); 

    showErrorMessage(context, e.code); 
  }
}
void showErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showAuthErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Authentication Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SizedBox(height: 50),

            //logo
             Image.asset('lib/google/chicken.png',width: 80,height: 80,),

           SizedBox(height: 15),
            //welcome back
          Text('Sign Up',style: TextStyle(color: Colors.grey[700],
          fontSize:30,
          fontWeight: FontWeight.bold,
          ),
          ),
           SizedBox(height: 8),

              //welcome back
          Text('Create your account',style: TextStyle(color: Colors.grey[700],
          fontSize:15,
          
          ),
          ),

          SizedBox(height: 25),

          Text_Fields(
            controller: nameController,
            text: 'Name',
            obscuretext: false,
            prefixIcon: Icon(Icons.person),
          ),
          SizedBox(height: 10),
            //username camp
          Text_Fields(
            controller: emailController,
            text: 'Email',
            obscuretext: false,
            prefixIcon: Icon(Icons.email),
          ),

          SizedBox(height: 10),
            //password camp
          Text_Fields(
            controller: passwordController,
            text: 'Password',
            obscuretext: true,
            prefixIcon: Icon(Icons.password),
            
          ),
          SizedBox(height: 10),

           Text_Fields(
            controller: confirmPasswordController,
            text: 'Password confirm',
            obscuretext: true,
            prefixIcon: Icon(Icons.password),
          ),

          SizedBox(height: 10),
            //forgot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
               
              ),
            ),
          
            SizedBox(height: 20),
            //sign in button
            MyButton(
              text: 'Sign Up',
              onTap: () => signUserUp(context),
            ),

            SizedBox(height: 25),
            //or continue with
           
            Text('Or continue with'),
            SizedBox(height: 5),
            //google
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
            //not a member? register

             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",style: TextStyle(color:Colors.grey[700])),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Text('Login',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
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