import 'package:flutter/material.dart';

class Navigation1 {
  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home_student');
        break;
      case 1:
        Navigator.pushNamed(context, '/courses');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushNamed(context, '/report');
        break;
      case 4:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }
}
