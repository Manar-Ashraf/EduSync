import 'package:flutter/material.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({super.key, required this.subjectName,required this.className});
  final String subjectName; 
  final String className;

  @override
  State<ClassDetails> createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
        ),
      ),
    );
  }
}