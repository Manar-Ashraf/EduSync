import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_sync/controllers/input_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
    required BuildContext context, 
  }) async {
    String? emailError = InputValidation.validateEmail(email);
    String? passwordError = InputValidation.validatePassword(password);
    String? confirmPasswordError = InputValidation.validateConfirmPassword(password, confirmPassword);

    if (emailError != null || passwordError != null || confirmPasswordError != null) {
      String errorMessage = emailError ?? passwordError ?? confirmPasswordError!;
      showSnackBar(context, errorMessage, Colors.red);
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
         'name': name,  
        'email': email,
        'role': role,
        'phone': '', 
        'gender': 'Female', 
        'level': null, 
        'subject': null,
        'createdAt': FieldValue.serverTimestamp(),
        });

        showSnackBar(context, 'Account created successfully!', Colors.green);
        Navigator.pop(context, '/signin');
      }
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}', Colors.red);
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 1),
      ),
    );
  }
}


