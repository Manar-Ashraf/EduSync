import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceStudent extends StatefulWidget {
  const AttendanceStudent({super.key});

  @override
  State<AttendanceStudent> createState() => _AttendanceStudentState();
}

class _AttendanceStudentState extends State<AttendanceStudent> {
  int _currentIndex = 1;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchAttendance(_focusedDay);
  }

  Future<void> fetchAttendance(DateTime selectedDate) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      QuerySnapshot enrollmentsSnapshot =
          await FirebaseFirestore.instance
              .collection('enrollments')
              .where('studentId', isEqualTo: user.uid)
              .get();

      List<Map<String, String>> tempAttendanceList = [];

      for (var enrollment in enrollmentsSnapshot.docs) {
        String subjectId = enrollment['subjectId'];

        var subjectSnapshot =
            await FirebaseFirestore.instance
                .collection('subjects')
                .doc(subjectId)
                .get();
        String subjectName =
            subjectSnapshot.exists
                ? subjectSnapshot['name']
                : "Unknown Subject";

        DateTime start = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        DateTime end = start.add(const Duration(days: 1));

        Timestamp startTimestamp = Timestamp.fromDate(start);
        Timestamp endTimestamp = Timestamp.fromDate(end);

        var attendanceSnapshot =
            await FirebaseFirestore.instance
                .collection('enrollments')
                .doc(enrollment.id)
                .collection('attendance')
                .where('date', isGreaterThanOrEqualTo: startTimestamp)
                .where('date', isLessThan: endTimestamp)
                .get();

        if (attendanceSnapshot.docs.isNotEmpty) {
          bool isPresent = attendanceSnapshot.docs.first['present'] ?? false;
          tempAttendanceList.add({
            'subject': subjectName,
            'status': isPresent ? 'Present' : 'Absent',
          });
        } else {
          print("No Attendance Record for Subject: $subjectName");
          tempAttendanceList.add({'subject': subjectName, 'status': 'Pending'});
        }
      }

      setState(() {
        attendanceList = tempAttendanceList;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 126, 128),
        toolbarHeight: 75,
        title: Text(
          "Attendance",
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TableCalendar(
              rowHeight: 35,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                fetchAttendance(selectedDay);
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF4EAAA6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF4EAAA6),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Course",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child:
                        attendanceList.isEmpty
                            ? const Center(child: Text("No attendance records"))
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: attendanceList.length,
                              itemBuilder: (context, index) {
                                return AttendanceRow(
                                  course: attendanceList[index]['subject'],
                                  status: attendanceList[index]['status'],
                                );
                              },
                            ),
                  ),
                ],
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

class AttendanceRow extends StatelessWidget {
  final String course;
  final String status;

  const AttendanceRow({super.key, required this.course, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(course, style: const TextStyle(fontSize: 16)),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  status == "Present"
                      ? Colors.green
                      : (status == "Absent" ? Colors.red : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
