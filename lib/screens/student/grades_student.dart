import 'package:flutter/material.dart';
import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GradesStudent extends StatefulWidget {
  final String subjectName;
  const GradesStudent({super.key, required this.subjectName});

  @override
  State<GradesStudent> createState() => _GradesStudentState();
}

class _GradesStudentState extends State<GradesStudent> {
  int _currentIndex = 1;
  List<Map<String, dynamic>> _grades = [];
  double _totalScore = 0;
  double _totalMaxScore = 0;
  double _scorePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final subjectQuery =
          await FirebaseFirestore.instance
              .collection('subjects')
              .where('name', isEqualTo: widget.subjectName)
              .limit(1)
              .get();

      if (subjectQuery.docs.isEmpty) return;
      final subjectId = subjectQuery.docs.first.id;

      QuerySnapshot enrollmentsSnapshot =
          await FirebaseFirestore.instance
              .collection('enrollments')
              .where('studentId', isEqualTo: user.uid)
              .where('subjectId', isEqualTo: subjectId)
              .limit(1)
              .get();

      if (enrollmentsSnapshot.docs.isEmpty) {
        return;
      }

      String enrollmentId = enrollmentsSnapshot.docs.first.id;

      QuerySnapshot gradesSnapshot =
          await FirebaseFirestore.instance
              .collection('enrollments')
              .doc(enrollmentId)
              .collection('grades')
              .get();

      if (gradesSnapshot.docs.isEmpty) {
        return;
      }

      List<Map<String, dynamic>> grades = [];
      double totalScore = 0;
      double totalMaxScore = 0;

      for (var doc in gradesSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        double score = 0;
        double maxScore = 0;

        if (data['score'] != null) {
          if (data['score'] is num) {
            score = (data['score'] as num).toDouble();
          } else if (data['score'] is String) {
            score = double.tryParse(data['score']) ?? 0;
          }
        }

        if (data['maxScore'] != null) {
          if (data['maxScore'] is num) {
            maxScore = (data['maxScore'] as num).toDouble();
          } else if (data['maxScore'] is String) {
            maxScore = double.tryParse(data['maxScore']) ?? 0;
          }
        }

        grades.add({
          'name': data['assignment'],
          'score': score,
          'maxScore': maxScore,
        });

        totalScore += score;
        totalMaxScore += maxScore;
      }

      final orderedGrades = _orderGrades(grades);

      setState(() {
        _grades = orderedGrades;
        _totalScore = totalScore;
        _totalMaxScore = totalMaxScore;
        _scorePercentage = totalMaxScore > 0 ? totalScore / totalMaxScore : 0;
      });
    } catch (e) {
      print("Error fetching grades: $e");
    }
  }

  List<Map<String, dynamic>> _orderGrades(List<Map<String, dynamic>> grades) {
    const order = [
      'Quiz 1',
      'Quiz 2',
      'Assignment',
      'Midterm exam',
      'Final exam',
    ];

    final orderMap = {for (var i = 0; i < order.length; i++) order[i]: i};

    grades.sort((a, b) {
      final indexA = orderMap[a['name']] ?? order.length;
      final indexB = orderMap[b['name']] ?? order.length;
      return indexA.compareTo(indexB);
    });

    return grades;
  }

  String _getEncouragementMessage(double percentage) {
    if (percentage >= 0.85) {
      return "Excellent work!";
    } else if (percentage >= 0.75) {
      return "You're doing really great!";
    } else if (percentage >= 0.60) {
      return "You're getting there! A little more effort!";
    } else if (percentage >= 0.50) {
      return "You can improve with more practice!";
    } else {
      return "You need more practice!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final encouragementMessage = _getEncouragementMessage(_scorePercentage);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 242, 243, 243)),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 55,
                lineWidth: 4.0,
                percent: _scorePercentage,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Score",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${(_scorePercentage * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                progressColor: const Color.fromARGB(255, 5, 126, 128),
                backgroundColor: Color.fromARGB(255, 242, 243, 243),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(height: 15),
              Text(
                encouragementMessage,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 215, 215),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (var grade in _grades) ...[
                      ScoreRow(
                        label: grade['name'],
                        points:
                            grade['score'] != null
                                ? "${grade['score']} points"
                                : "Pending",
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color.fromARGB(255, 233, 232, 232),
                      ),
                    ],
                    ScoreRow(
                      label: "TOTAL",
                      points: "$_totalScore / $_totalMaxScore points",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar1(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigation1.onItemTapped(context, index);
        },
      ),
    );
  }
}

class ScoreRow extends StatelessWidget {
  final String label;
  final String points;

  const ScoreRow({super.key, required this.label, required this.points});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            points,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
