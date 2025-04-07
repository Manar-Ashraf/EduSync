import 'package:fl_chart/fl_chart.dart';
import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportStudent extends StatefulWidget {
  const ReportStudent({super.key});

  @override
  State<ReportStudent> createState() => _ReportStudentState();
}

class _ReportStudentState extends State<ReportStudent> {
  int _currentIndex = 3;

  List<Map<String, dynamic>> scores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentGrades();
  }

  Future<void> fetchStudentGrades() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Get student's enrollments
      final enrollments = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('studentId', isEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> tempScores = [];

      for (final enrollment in enrollments.docs) {
        final subjectId = enrollment['subjectId'];
        
        // Get subject name
        final subjectDoc = await FirebaseFirestore.instance
            .collection('subjects')
            .doc(subjectId)
            .get();
        
        final subjectName = subjectDoc['name'] ?? 'Unknown Subject';

        // Get grades for this enrollment
        final grades = await enrollment.reference
            .collection('grades')
            .get();

        double totalScore = 0;
        double totalMaxScore = 0;

        for (final grade in grades.docs) {
          totalScore += _parseNumber(grade['score']);
          totalMaxScore += _parseNumber(grade['maxScore']);
        }

        final percentage = totalMaxScore > 0 
            ? (totalScore / totalMaxScore) * 100 
            : 0;

        tempScores.add({
          'course': subjectName.toUpperCase(),
          'score': percentage.round(),
        });
      }

      setState(() {
        scores = tempScores;
        isLoading = false;
      });

    } catch (e) {
      print("Error fetching grades: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading report")),
      );
    }
  }

  double _parseNumber(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
       appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 126, 128),
        toolbarHeight: 75,
        title: Text(
          "Report",
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 5, 126, 128),))
          : scores.isEmpty
              ? const Center(child: Text("No grades available"))
              : Column(
        children: [
          SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 350,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < scores.length) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                scores[index]['course'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 80,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          );
                        },
                        reservedSize: 28,
                        interval: 20,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),

                  barGroups:
                      scores.asMap().entries.map((entry) {
                        final score = (entry.value['score'] as int).toDouble();

                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: 100,
                              color: Color.fromARGB(255, 5, 126, 128),
                              width: 10,
                              borderRadius: BorderRadius.zero,

                              rodStackItems: [
                                BarChartRodStackItem(
                                  0,
                                  score,
                                  Color.fromARGB(255, 5, 126, 128),
                                ),
                                BarChartRodStackItem(
                                  score,
                                  100,
                                  Color.fromARGB(255, 185, 215, 215),
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ],
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
