import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  signInWithGoogle() async{

    final GoogleSignInAccount? googleUser =  await GoogleSignIn().signIn();//util poate selecta contul

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;//se obtin tokenurile de auth

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken, //se creeaza un set de credentiale folosind tokenile obtinute
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);//utilizeaza vredentialele pentru autentificare
  }
}