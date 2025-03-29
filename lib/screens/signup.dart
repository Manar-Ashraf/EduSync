import 'package:edu_sync/controllers/firestore_storage.dart';
import 'package:edu_sync/widgets/custom_button.dart';
import 'package:edu_sync/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? selectedRole = 'Instructor';

  final Auth _authService = Auth();

  Future<void> _handleSignUp() async {
    await _authService.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      role: selectedRole!,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 243, 243),
        automaticallyImplyLeading: false,
        title: Text(
          'Sign Up',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 5),
            CustomTextField(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'Enter your name',
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 5),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'xxxx@gmail.com',
              icon: Icons.email_outlined,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 5),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
              icon: Icons.lock_outlined,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 5),
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              obscureText: true,
              icon: Icons.lock_outlined,
            ),
            SizedBox(height: 10),
            Row(
              children:
                  ['Instructor', 'Student', 'Parent']
                      .map(
                        (role) => Expanded(
                          child: ChoiceChip(
                            label: Text(role),
                            selected: selectedRole == role,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedRole = role;
                              });
                            },
                            selectedColor: Color.fromARGB(255, 5, 126, 128),
                            backgroundColor: Color.fromARGB(255, 242, 243, 243),
                          ),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 10),
            CustomButton(text: 'Sign Up', onPressed: _handleSignUp),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                'Already have an account? Log in',
                style: TextStyle(color: const Color.fromARGB(255, 12, 13, 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
