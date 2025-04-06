import 'package:flutter/material.dart';

class Navigation2 {
  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home_instructor');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile2');
        break;
      case 2:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }
}
