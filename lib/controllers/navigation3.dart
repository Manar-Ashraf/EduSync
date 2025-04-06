import 'package:edu_sync/screens/profile.dart';
import 'package:flutter/material.dart';

class Navigation3 {
  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home_parent');
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile2(userRole: 'parent'),
          ),
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }
}