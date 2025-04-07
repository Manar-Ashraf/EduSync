import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_sync/controllers/navigation2.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkAttendance extends StatefulWidget {
  final String subjectName;
  const MarkAttendance({super.key, required this.subjectName});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> students = [];

  // final List<Map<String, dynamic>> students = [
  //   {'name': 'Mazen Ashraf', 'present': true},
  //   {'name': 'Nadeen Hossam', 'present': true},
  //   {'name': 'Nourhan Mohammed', 'present': true},
  //   {'name': 'Marwan Rashad', 'present': false},
  //   {'name': 'Salma Hassan', 'present': false},
  //   {'name': 'Nancy Khaled', 'present': true},
  //   {'name': 'Adam Maged', 'present': true},
  //   {'name': 'Farida Emad', 'present': false},
  //   {'name': 'Hagar Mohsen', 'present': true},
  //   {'name': 'Eyad Hossam', 'present': true},
  // ];
  // final List<String> students = [
  //   'Mazen Ashraf',
  //   'Zeina Mohammed',
  //   'Nourhan Mohammed',
  //   'Marwan Rashad',
  //   'Salma Hassan',
  //   'Nancy Khaled',
  //   'Adam Maged',
  //   'Farida Emad',
  //   'Hagar Mohsen',
  //   'Eyad Hossam'
  // ];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final subjectQuery =
          await FirebaseFirestore.instance
              .collection('subjects')
              .where('name', isEqualTo: widget.subjectName)
              .limit(1)
              .get();

      if (subjectQuery.docs.isEmpty) return;

      final subjectId = subjectQuery.docs.first.id;

      final enrollmentQuery =
          await FirebaseFirestore.instance
              .collection('enrollments')
              .where('subjectId', isEqualTo: subjectId)
              .get();

      final studentData = await Future.wait(
        enrollmentQuery.docs.map((enrollment) async {
          final studentId = enrollment['studentId'];
          final userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(studentId)
                  .get();

          return {
            'enrollmentId': enrollment.id,
            'studentId': studentId,
            'name': userDoc['name'],
            'present': true,
          };
        }),
      );

      setState(() {
        students = studentData;
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 5, 126, 128),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int presentCount = students.where((s) => s['present']).length;
    int absentCount = students.length - presentCount;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 245),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AppBar(
              backgroundColor: const Color.fromARGB(255, 5, 126, 128),
              toolbarHeight: 100,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 5, 126, 128),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('d MMMM y').format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "${widget.subjectName} CLASS",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAttendanceCount(presentCount, "Present", Colors.green),
                  const SizedBox(width: 20),
                  _buildAttendanceCount(
                    absentCount,
                    "Absent",
                    Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Text(
                "Review or Edit Attendance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 215, 215),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 5, 126, 128),
                      ),
                    ),
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 5, 126, 128),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Text(
                            students[index]['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: students[index]['present'],
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  students[index]['present'] = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      if (index != students.length - 1)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 200, 200, 200),
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(_selectedDate);
                      for (var student in students) {
                        final enrollmentId = student['enrollmentId'];
                        final docRef = FirebaseFirestore.instance
                            .collection('enrollments')
                            .doc(enrollmentId)
                            .collection('attendance')
                            .doc(
                              formattedDate,
                            ); // This avoids time-specific duplication

                        await docRef.set({
                          'date': Timestamp.fromDate(_selectedDate),
                          'present': student['present'],
                          'markedBy':
                              'teacherUserId123', // You can replace this dynamically
                        });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Attendance saved successfully'),
                        ),
                      );
                    } catch (e) {
                      print('Error saving attendance: $e');
                    }
                  },
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

  Widget _buildAttendanceCount(int count, String label, Color numColor) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 215, 215),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: numColor,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
