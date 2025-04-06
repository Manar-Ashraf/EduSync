import 'package:edu_sync/controllers/navigation3.dart';
import 'package:edu_sync/screens/parent/student_report.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:edu_sync/widgets/custom_button.dart';
import 'package:edu_sync/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeParent extends StatefulWidget {
  const HomeParent({super.key});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  int _currentIndex = 0;
  String _name = '';
  String? _selectedLevel;
  String? _selectedExam;
  final List<String> _gradeLevels = List.generate(
    12,
    (index) => 'Grade ${index + 1}',
  );
  final List<String> _examTypes = ['First Term Exam', 'Second Term Exam'];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 243, 243, 1),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 5, 126, 128),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Hi, $_name",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Review Student Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter student name',
                  borderColor: const Color.fromARGB(255, 5, 126, 128),
                ),
                SizedBox(height: 10),
                Row(
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
                SizedBox(height: 5),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter student email',
                  icon: Icons.email_outlined,
                  borderColor: const Color.fromARGB(255, 5, 126, 128),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 5, 126, 128),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedLevel,
                    hint: const Text('Select Grade Level'),
                    isExpanded: true,
                    underline: const SizedBox(), // Remove default underline
                    items:
                        _gradeLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLevel = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Exam',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 5, 126, 128),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedExam,
                    hint: const Text('Select Exam Type'),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items:
                        _examTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedExam = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _selectedLevel != null &&
                        _selectedExam != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => StudentReport(
                                // studentName: _nameController.text,
                                // studentEmail: _emailController.text,
                                // studentLevel: _selectedLevel!,
                                // examType: _selectedExam!,
                              ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  backgroundColor: const Color.fromRGBO(242, 243, 243, 1),
                  textColor: Color.fromARGB(255, 5, 126, 128),
                  borderColor: const Color.fromARGB(255, 5, 126, 128),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar2(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigation3.onItemTapped(context, index);
        },
      ),
    );
  }
}
