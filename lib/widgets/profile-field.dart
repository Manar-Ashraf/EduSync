import 'package:edu_sync/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isEditable;
  final TextEditingController? controller;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isEditable = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        SizedBox(height: 5),
        isEditable
            ? CustomTextField(
              controller: controller!,
              labelText: label,
              hintText: value,
              icon: icon,
            )
            : Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 5, 126, 128),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, color: Color.fromARGB(255, 127, 132, 132)),
                  SizedBox(width: 10),
                  Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
                ],
              ),
            ),
      ],
    );
  }
}
