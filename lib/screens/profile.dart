import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_sync/controllers/navigation2.dart';
import 'package:edu_sync/controllers/navigation3.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:edu_sync/widgets/gender_dropdown.dart';
import 'package:edu_sync/widgets/profile-field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_sync/screens/signin.dart';
import 'package:edu_sync/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class Profile2 extends StatefulWidget {
  final String userRole;
  const Profile2({super.key, required this.userRole});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile2> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool isEditing = false;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _gender = 'Female';
  String _subject = '';
  late String _role ;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _role = widget.userRole;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? '';
          _email = userDoc['email'] ?? '';
          _phone = userDoc['phone'] ?? '';
          _gender = userDoc['gender'] ?? 'Female';
          _subject = userDoc['subject'] != null ? "${userDoc['subject']}" : "";

          _nameController.text = _name;
          _phoneController.text = _phone;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'gender': _gender,
      });

      setState(() {
        _name = _nameController.text;
        _phone = _phoneController.text;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  void _handleBottomBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (_role == 'parent') {
      Navigation3.onItemTapped(context, index);
    } else {
      Navigation2.onItemTapped(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/Profile2.png',
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                if (isEditing) {
                                  _updateUserData();
                                } else {
                                  setState(() => isEditing = true);
                                }
                              },
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.teal,
                                child: Icon(
                                  isEditing ? Icons.save : Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _subject,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ProfileField(
                      label: 'Your Email',
                      value: _email,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 10),
                    ProfileField(
                      label: 'Phone Number',
                      value: _phone,
                      icon: Icons.phone,
                      isEditable: isEditing,
                      controller: _phoneController,
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
                    isEditing
                        ? GenderDropdown(
                          selectedGender: _gender,
                          onChanged: (String newValue) {
                            setState(() => _gender = newValue);
                          },
                        )
                        : ProfileField(
                          label: '',
                          value: _gender,
                          icon: Icons.person,
                        ),
                    SizedBox(height: 30),
                    CustomButton(
                      text: 'Logout',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signin()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BottomBar2(
              currentIndex: _selectedIndex,
              onTap: _handleBottomBarTap,
            ),
          ],
        ),
      ),
    );
  }
}
