import 'package:edu_sync/screens/profile.dart';
import 'package:flutter/material.dart';

class Navigation2 {
  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home_instructor');
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile2(userRole: 'instructor'),
          ),
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }
}
