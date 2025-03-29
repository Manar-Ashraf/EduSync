import 'package:flutter/material.dart';

class BottomBar1 extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar1({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 5, 126, 128),
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Courses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.grading_outlined),
            label: 'Report',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
    );
  }
}
