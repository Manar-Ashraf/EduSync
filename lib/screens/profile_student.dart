import 'package:edu_sync/navigation.dart';
import 'package:edu_sync/screens/signin.dart';
import 'package:edu_sync/widgets/custom_button.dart';
import 'package:edu_sync/widgets/custom_text_field.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Profile> {
  String? selectedGender = 'Female';
  final List<String> genderOptions = ['Male', 'Female'];
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/Profile.png',
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Manar Ashraf',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Level 10',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      labelText: 'Email',
                      hintText: 'manar@gmail.com',
                      icon: Icons.email_outlined,
                      borderColor: Color.fromARGB(255, 5, 126, 128),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      labelText: 'Phone Number',
                      hintText: '+20 126 790 5844',
                      icon: Icons.local_phone_outlined,
                      borderColor: Color.fromARGB(255, 5, 126, 128),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      labelText: 'Password',
                      hintText: '**********',
                      obscureText: true,
                      icon: Icons.lock_outlined,
                      borderColor: Color.fromARGB(255, 5, 126, 128),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 5, 126, 128),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: selectedGender,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down),
                        dropdownColor: Color.fromARGB(255, 242, 243, 243),
                        items:
                            genderOptions.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Logout',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signin()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              BottomBar1(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigation1.onItemTapped(context, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
