import 'package:flutter/material.dart';

class GenderDropdown extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 5, 126, 128), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: selectedGender,
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down),
        dropdownColor: Color.fromARGB(255, 242, 243, 243),
        items:
            ['Male', 'Female'].map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}
