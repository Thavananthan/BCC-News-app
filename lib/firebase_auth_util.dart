
import 'package:firebase_auth/firebase_auth.dart';

abstract  class Authfunc{
  Future <String> SignIn(String email, String password);

  Future <String> SignUp(String email,String password);

  Future <FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerfication();

  Future<void> SignOut();

  Future<bool> IsEmailVerified();

}

class MyAuth implements Authfunc{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  @override
  Future<String> SignIn(String email, String password) async {
     var user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password) ).user;
     return user.uid;
  }

  @override
  Future<void> SignOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> SignUp(String email, String password) async {
    var user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password) ).user;
    return user.uid;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  @override
  Future<void> sendEmailVerfication() async {
    var user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();

  }

  @override
  Future<bool> IsEmailVerified() async {
    var user = await _firebaseAuth.currentUser();
   return user.isEmailVerified;
}
}