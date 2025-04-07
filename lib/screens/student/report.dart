import 'package:fl_chart/fl_chart.dart';
import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:flutter/material.dart';

class ReportStudent extends StatefulWidget {
  const ReportStudent({super.key});

  @override
  State<ReportStudent> createState() => _ReportStudentState();
}

class _ReportStudentState extends State<ReportStudent> {
  int _currentIndex = 3;

  List<Map<String, dynamic>> scores = [
    {'course': 'MATHEMATICS', 'score': 100},
    {'course': 'SCIENCE', 'score': 80},
    {'course': 'ENGLISH', 'score': 90},
    {'course': 'FRENCH', 'score': 70},
    {'course': 'ARABIC', 'score': 68},
    {'course': 'COMPUTER', 'score': 100},
    {'course': 'ART', 'score': 90},
    {'course': 'MUSIC', 'score': 70},
    {'course': 'HISTORY', 'score': 75},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      body: Column(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 5, 126, 128),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Report",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

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
