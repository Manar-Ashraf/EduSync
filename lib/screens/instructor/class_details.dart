import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_sync/controllers/navigation2.dart';
import 'package:edu_sync/screens/instructor/add_grades.dart';
import 'package:edu_sync/screens/instructor/mark_attendance.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:flutter/material.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({
    super.key,
    required this.subjectName,
    required this.className,
  });
  final String subjectName;
  final String className;

  @override
  State<ClassDetails> createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  int _currentIndex = 0;
  List<String> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

Future<void> fetchStudents() async {
    try {
      final subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .where('name', isEqualTo: widget.subjectName)
          .get();

      if (subjectSnapshot.docs.isEmpty) return;

      final subjectId = subjectSnapshot.docs.first.id;

      final enrollmentsSnapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('subjectId', isEqualTo: subjectId)
          .get();

      List<Map<String, String>> fetchedStudents = [];

      for (var enrollment in enrollmentsSnapshot.docs) {
        final studentId = enrollment['studentId'];
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(studentId).get();

        if (userDoc.exists) {
          fetchedStudents.add({
            'name': userDoc['name'],
            'className': widget.className,
          });
        }
      }

      setState(() {
        students = fetchedStudents.map((student) => student['name'] ?? '').toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching students: $e");
    }
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
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MarkAttendance(subjectName: widget.subjectName),
                      ),
                    );
                  },
                  child: _buildFeatureButton(
                    Icons.calendar_today_outlined,
                    "Mark Student\nAttendance",
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AddGrades(subjectName: widget.subjectName),
                      ),
                    );
                  },
                  child: _buildFeatureButton(
                    Icons.add_chart,
                    "Add Student\nMarks",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Student Details (${students.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Color.fromARGB(255, 5, 126, 128)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator(color: const Color.fromARGB(255, 5, 126, 128),))
                      : students.isEmpty
                      ? const Center(
                        child: Text('No students found for this subject.'),
                      )
                      : ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 5, 126, 128),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              leading: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Color.fromARGB(
                                  255,
                                  185,
                                  215,
                                  215,
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 40,
                                  color: Color.fromARGB(255, 95, 99, 99),
                                ),
                              ),
                              title: Text(
                                students[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                'Class - ${widget.className}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 5, 126, 128),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
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

Widget _buildFeatureButton(IconData icon, String label) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 185, 215, 215),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black, size: 40),
      ),
      const SizedBox(height: 5),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ],
  );
}
