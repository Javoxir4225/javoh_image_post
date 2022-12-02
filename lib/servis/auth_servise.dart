import 'package:firebase_auth/firebase_auth.dart';

String errorText = "";
String errorText1 = "";

class AuthServise {
  static final auth = FirebaseAuth.instance;
  static Future<User?> signInUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = auth.currentUser;
      print(firebaseUser.toString());
      return firebaseUser;
    } catch (e) {
      print("catch eror: $e");
      errorText = e.toString();
    }
    return null;
  }

  static Future<User?> signUpUser(
       String email, String password) async {
    try {
      final userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCred.user;
      print(user.toString());
      return user;
    } catch (e) {
      print(e);
      errorText1 = e.toString();
    }
    return null;
  }

  // static Future<User?> signinUser(String email,String password)async{
  // try {
  //  final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //  final user = userCred.user;
  //  print(user.toString());
  //  return user;
  // } catch (e) {
  //   print(e);
  // }
  // return null;
  // }
  static void signOutUser() async {
    await auth.signOut();
  }
}
