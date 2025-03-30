import 'package:flutter/material.dart';

class Navigation1 {
  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushNamed(context, '/notes');
        break;
      case 3:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }
}
