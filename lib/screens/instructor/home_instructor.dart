import 'package:edu_sync/controllers/navigation2.dart';
import 'package:edu_sync/screens/instructor/class_details.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:edu_sync/widgets/class_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeInstructor extends StatefulWidget {
  const HomeInstructor({super.key});

  @override
  State<HomeInstructor> createState() => _HomeInstructorState();
}

class _HomeInstructorState extends State<HomeInstructor> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  int _currentIndex = 0;
  String _name = '';
  final List<String> _studentCounts = ['10', '10', '10', '10', '10', '10'];
  final List<Map<String, String>> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchTeacherClasses();
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

  Future<void> fetchTeacherClasses() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final subjectsQuery =
          await _firestore
              .collection('subjects')
              .where('teacherId', isEqualTo: user.uid)
              .get();

      for (var i = 0; i < subjectsQuery.docs.length; i++) {
        final subjectDoc = subjectsQuery.docs[i];
        final subjectName = subjectDoc['name'] as String? ?? 'No Subject';

        final classDocs =
            await _firestore
                .collection('subjects')
                .doc(subjectDoc.id)
                .collection('class')
                .get();

        // Create a class card for each class
        for (var j = 0; j < classDocs.docs.length; j++) {
          final classDoc = classDocs.docs[j];
          final className = classDoc['className'] as String? ?? 'N/A';

          final studentCount = _studentCounts[(i + j) % _studentCounts.length];

          _classes.add({
            'subject': subjectName,
            'students': studentCount,
            'class': className,
            'subjectId': subjectDoc.id,
            'classId': classDoc.id,
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching classes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
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
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 5, 126, 128),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                "My Classes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.teal),
              ),
            )
          else if (_classes.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No classes assigned",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  final classData = _classes[index];
                  return ClassCard(
                    subject: classData['subject']!,
                    students: classData['students']!,
                    className: classData['class']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ClassDetails(
                                subjectName: classData['subject']!,
                                className: classData['class']!,
                              ),
                        ),
                      );
                    },
                  );
                },
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
          Navigation2.onItemTapped(context, index);
        },
      ),
    );
  }
}
