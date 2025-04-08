import 'package:edu_sync/controllers/navigation2.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddGrades extends StatefulWidget {
  final String subjectName;
  const AddGrades({super.key, required this.subjectName});

  @override
  State<AddGrades> createState() => _AddGradesState();
}

class _AddGradesState extends State<AddGrades> {
  int _currentIndex = 0;
  String selectedType = 'Assignment';
  List<Map<String, dynamic>> studentList = [];
  final Map<String, TextEditingController> gradeControllers = {};

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final subjectSnapshot =
        await FirebaseFirestore.instance
            .collection('subjects')
            .where('name', isEqualTo: widget.subjectName)
            .get();

    if (subjectSnapshot.docs.isEmpty) return;

    final subjectId = subjectSnapshot.docs.first.id;

    final enrollmentsSnapshot =
        await FirebaseFirestore.instance
            .collection('enrollments')
            .where('subjectId', isEqualTo: subjectId)
            .get();

    List<Map<String, dynamic>> tempList = [];

    for (var doc in enrollmentsSnapshot.docs) {
      final studentId = doc['studentId'];
      final userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(studentId)
              .get();

      if (userSnapshot.exists) {
        final name = userSnapshot['name'];
        gradeControllers[doc.id] = TextEditingController();
        tempList.add({
          'enrollmentId': doc.id,
          'studentId': studentId,
          'name': name,
        });
      }
    }

    setState(() {
      studentList = tempList;
    });
  }

  Future<void> submitGrades() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to submit grades.'),
        ),
      );
      return;
    }

    final Map<String, int> maxScores = {
      'Quiz 1': 10,
      'Quiz 2': 10,
      'Assignments': 10,
      'Mid Term Exam': 20,
      'Final Exam': 50,
    };

    final now = Timestamp.now();
    final maxScore = maxScores[selectedType] ?? 10;

    for (var student in studentList) {
      final enrollmentId = student['enrollmentId'];
      final scoreText = gradeControllers[enrollmentId]?.text ?? '';
      final score = int.tryParse(gradeControllers[enrollmentId]!.text);

      if (score != null) {
        await FirebaseFirestore.instance
            .collection('enrollments')
            .doc(enrollmentId)
            .collection('grades')
            .add({
              'assignment': selectedType,
              'score': score,
              'maxScore': maxScore,
              'date': now,
              'givenBy': currentUser.uid,
            });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 245),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 126, 128),
        toolbarHeight: 75,
        title: Text(
          "${widget.subjectName} CLASS",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Add Student Grades',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  items:
                      [
                            'Quiz 1',
                            'Quiz 2',
                            'Assignment',
                            'Mid Term Exam',
                            'Final Exam',
                          ]
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 145, 160, 160),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 5, 126, 128),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 5, 126, 128),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 5, 126, 128),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 215, 215),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 126, 128),
                      ),
                    ),
                    Text(
                      'Grade',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 126, 128),
                      ),
                    ),
                  ],
                ),
              ),
              ...studentList.asMap().entries.map((entry) {
                final index = entry.key;
                final student = entry.value;

                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        student['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 60,
                        height: 30,
                        child: TextField(
                          cursorColor: const Color.fromARGB(255, 5, 126, 128),
                          controller: gradeControllers[student['enrollmentId']],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Score",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            fillColor: const Color.fromARGB(255, 185, 215, 215),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index != studentList.length - 1)
                      const Divider(color: Color.fromARGB(255, 185, 184, 184)),
                  ],
                );
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitGrades,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 245, 245),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: Color.fromARGB(255, 5, 126, 128),
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 126, 128),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
