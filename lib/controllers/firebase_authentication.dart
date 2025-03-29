import 'package:edu_sync/controllers/firebase_error_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; 
    } on FirebaseAuthException catch (e) {
      return AuthError.getErrorMessage(e.code);
    } catch (e) {
      return "An unexpected error occurred. Please try again.";
    }
  }
}