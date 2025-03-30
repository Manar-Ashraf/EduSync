import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_sync/controllers/firebase_error_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String role = userDoc['role'] ?? '';

          return role;
        } else {
          return 'User data not found!';
        }
      }
      return 'User sign-in failed!';
    } on FirebaseAuthException catch (e) {
      return AuthError.getErrorMessage(e.code);
    } catch (e) {
      return "An unexpected error occurred. Please try again.";
    }
  }
}
