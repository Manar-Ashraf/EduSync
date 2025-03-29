import 'package:edu_sync/widgets/custom_button.dart';
import 'package:edu_sync/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? selectedRole = 'Instructor';

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
            CustomTextField(labelText: 'Name', hintText: 'Enter your name'),
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
            CustomTextField(labelText: 'Email', hintText: 'xxxx@gmail.com', icon: Icons.email_outlined), 
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
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              obscureText: true,
              icon: Icons.lock_outlined,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text('Instructor'),
                    selected: selectedRole == 'Instructor',
                    onSelected: (bool selected) {
                      setState(() {
                        selectedRole = 'Instructor';
                      });
                    },
                    selectedColor: Color.fromARGB(255, 5, 126, 128),
                    backgroundColor: Color.fromARGB(255, 242, 243, 243),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Student'),
                    selected: selectedRole == 'Student',
                    onSelected: (bool selected) {
                      setState(() {
                        selectedRole = 'Student';
                      });
                    },
                    selectedColor: Color.fromARGB(255, 5, 126, 128),
                    backgroundColor: Color.fromARGB(255, 242, 243, 243),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Parent'),
                    selected: selectedRole == 'Parent',
                    onSelected: (bool selected) {
                      setState(() {
                        selectedRole = 'Parent';
                      });
                    },
                    selectedColor: Color.fromARGB(255, 5, 126, 128),
                    backgroundColor: Color.fromARGB(255, 242, 243, 243),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'Sign Up',
              onPressed: () {
                // Add sign-up functionality
              },
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   style: TextButton.styleFrom(
            //     splashFactory: NoSplash.splashFactory, 
            //   ),
            //   child: Text(
            //     'Already have an account? Log in',
            //     style: TextStyle(color: const Color.fromARGB(255, 12, 13, 13)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
