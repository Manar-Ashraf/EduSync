import 'package:edu_sync/controllers/navigation3.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:edu_sync/widgets/subject_report.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentReport extends StatefulWidget {
  final String studentName;
  final String studentEmail;
  final String studentLevel;
  final String examType;

  const StudentReport({
    super.key,
    required this.studentName,
    required this.studentEmail,
    required this.studentLevel,
    required this.examType,
  });

  @override
  State<StudentReport> createState() => _StudentReportState();
}

class _StudentReportState extends State<StudentReport> {
  int _currentIndex = 0;
  Map<String, num> subjectScores = {};
  bool isLoading = true;
  final bool _hasAccess = true;

  @override
  void initState() {
    super.initState();
    fetchStudentReport();
  }

  Future<void> fetchStudentReport() async {
    try {
      setState(() => isLoading = true);

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No user logged in");
        return;
      }

      final studentQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: widget.studentEmail)
              .limit(1)
              .get();

      if (studentQuery.docs.isEmpty) {
        print("Student not found");
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Student not found")));
        return;
      }

      final studentId = studentQuery.docs.first.id;
      final studentData = studentQuery.docs.first.data();

      final enrollmentsQuery =
          await FirebaseFirestore.instance
              .collection('enrollments')
              .where('studentId', isEqualTo: studentId)
              .get();

      double parseNumber(dynamic value) {
        if (value == null) return 0.0;

        if (value is num) {
          return value.toDouble();
        }

        if (value is String) {
          return double.tryParse(value) ?? 0.0;
        }

        return 0.0;
      }

      final tempScores = <String, num>{};


      for (final enrollment in enrollmentsQuery.docs) {
        final subjectId = enrollment['subjectId'];

        final subjectDoc =
            await FirebaseFirestore.instance
                .collection('subjects')
                .doc(subjectId)
                .get();

        final subjectName = subjectDoc['name'] ?? 'Unknown Subject';

        final gradesQuery =
            await enrollment.reference.collection('grades').get();

        double totalScore = 0;
        double totalMaxScore = 0;

        for (final grade in gradesQuery.docs) {
          final score = parseNumber(grade['score']);
          final maxScore = parseNumber(grade['maxScore']);

          totalScore += score;
          totalMaxScore += maxScore;
        }

        final percentage =
            totalMaxScore > 0 ? (totalScore / totalMaxScore) * 100 : 0;
        tempScores[subjectName] = percentage;
      }

      setState(() {
        subjectScores = tempScores;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching report: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading report: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 126, 128),
        toolbarHeight: 75,
        title: Text(
          widget.examType,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 115,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/Profile.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(
                          value:
                              subjectScores.isNotEmpty
                                  ? subjectScores.values.reduce(
                                        (a, b) => a + b,
                                      ) /
                                      (subjectScores.length * 100)
                                  : 0,
                          strokeWidth: 5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 5, 126, 128),
                          ),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      Text(
                        subjectScores.isNotEmpty
                            ? "${(subjectScores.values.reduce((a, b) => a + b) / subjectScores.length).toStringAsFixed(0)}%"
                            : "0%",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.studentName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              if (!_hasAccess)
                const Center(
                  child: Text("You don't have permission to view this report"),
                )
              else if (isLoading)
                const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 5, 126, 128),))
              else if (subjectScores.isEmpty)
                const Center(child: Text("No report data available"))
              else
                ...subjectScores.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SubjectRow(
                      subject: entry.key,
                      score: entry.value.toInt(),
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
          Navigation3.onItemTapped(context, index);
        },
      ),
    );
  }
}


