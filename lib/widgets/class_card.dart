import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String subject;
  final String students;
  final String className;
  final VoidCallback? onTap;

  const ClassCard({super.key, 
    required this.subject,
    required this.students,
    required this.className, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,  
      borderRadius: BorderRadius.circular(30),  
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 5, 126, 128)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 5),
                    Text("No. of Students - $students"),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.class_, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 5),
                    Text("Class - $className"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
