import 'package:edu_sync/controllers/navigation2.dart';
import 'package:edu_sync/widgets/bottom_bar_2.dart';
import 'package:flutter/material.dart';

class AddGrades extends StatefulWidget {
    final String subjectName;
  const AddGrades({super.key, required this.subjectName});

  @override
  State<AddGrades> createState() => _AddGradesState();
}

class _AddGradesState extends State<AddGrades> {
  int _currentIndex = 0;

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