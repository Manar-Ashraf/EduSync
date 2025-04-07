import 'package:flutter/material.dart';

class SubjectRow extends StatelessWidget {
  final String subject;
  final int score;

  const SubjectRow({super.key, required this.subject, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                child: Text(
                  "$score%",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: score / 100,
            minHeight: 5,
            backgroundColor: const Color.fromARGB(255, 149, 195, 196),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 5, 126, 128),
            ),
          ),
        ],
      ),
    );
  }
}