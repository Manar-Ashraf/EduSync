import 'package:flutter/material.dart';

class MarkAttendance extends StatefulWidget {
  final String subjectName;
  const MarkAttendance({super.key, required this.subjectName});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
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

      

    );
  }
}