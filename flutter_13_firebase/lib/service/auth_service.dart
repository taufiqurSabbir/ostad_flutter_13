
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign up

  Future<User?>signUp(String email,String password) async {
    final result =await _auth.createUserWithEmailAndPassword(email: email, password: password);
    result.user!.sendEmailVerification();
    print(result.user);
    return result.user;
  }

  //login

  Future<User?>login(String email,String password) async {
    final result =await _auth.signInWithEmailAndPassword(email: email, password: password);
    print(result.user);
    return result.user;
  }


  Future<void>resetPassword(String email) async {
   await _auth.sendPasswordResetEmail(email: email);
  }

  //google sign in

  Future<User?>signInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();

  print(googleUser);

  if(googleUser == null) return null ;

  final googleAuth =await googleUser.authentication;
  print(googleAuth);

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken
  );

  final result = await _auth.signInWithCredential(credential);
  return result.user;
  }
}