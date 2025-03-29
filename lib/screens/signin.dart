import 'package:edu_sync/controllers/firebase_authentication.dart';
import 'package:edu_sync/controllers/input_validation.dart';
import 'package:edu_sync/screens/signup.dart';
import 'package:edu_sync/widgets/custom_button.dart';
import 'package:edu_sync/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = Auth();

  String? errorMessage;

  void _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validate input before sending request
    String? emailError = InputValidation.validateEmail(email);
    String? passwordError = InputValidation.validatePassword(password);

    if (emailError != null || passwordError != null) {
      setState(() {
        errorMessage = emailError ?? passwordError;
      });
      return;
    }

    // Authenticate using Firebase
    String? error = await _authService.signIn(email, password);
    if (error != null) {
      setState(() {
        errorMessage = error;
      });
    } else {
      // Navigate to the home screen on successful login
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@') || !email.endsWith('.com')) {
      return 'Email must contain @ and end with .com';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset('assets/images/Signin.png', height: 200),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to \nEduSync',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'xxxx@gmail.com',
                  icon: Icons.email_outlined,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  icon: Icons.lock_outlined,
                  validator: _validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Add forgot password
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 127, 132, 132),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (errorMessage != null)
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),

                CustomButton(text: 'Log in', onPressed: _handleSignIn),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    'New to EduSync? Sign up',
                    style: TextStyle(color: Color.fromARGB(255, 12, 13, 13)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
