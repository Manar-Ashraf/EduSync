import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  int _currentIndex = 0;
   String _name = '';
    
  List<Map<String, String>> leaders = [
    {'name': 'Adam Maged', 'subject': 'Science'},
    {'name': 'Farida Emad', 'subject': 'Math'},
    {'name': 'Marwan Emad', 'subject': 'English'},
    {'name': 'Nancy Khaled', 'subject': 'Computer'},
  ];
  List<Map<String, String>> achievements = [
    {'title': '1st Rank', 'icon': 'assets/icons/badge.png'},
    {'title': 'Reading Champion', 'icon': 'assets/icons/badge (1).png'},
    {'title': 'Sports Star', 'icon': 'assets/icons/badge (2).png'},
  ];

   @override
  void initState() {
   super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? ''; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 5, 126, 128),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25), 
                bottomRight: Radius.circular(25),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Hi, $_name 👋",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Handle notifications
                    },
                  ),
                ],
              ),
            ),
          ),
      
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Leaderboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 26,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: leaders.length,
                itemBuilder: (context, index) {
                  final leader = leaders[index];
                  String imagePath =
                      index % 2 == 0
                          ? "assets/images/Profile3.png"
                          : "assets/images/Profile.png";
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 185, 215, 215),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 246, 135, 75),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(imagePath, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          leader['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          leader['subject']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Achievement',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    achievements.map((achievement) {
                      return Column(
                        children: [
                          Image.asset(
                            achievement['icon']!,
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            achievement['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),    
      ],
      ),
      bottomNavigationBar: BottomBar1(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigation1.onItemTapped(context, index);
        },
      ),       
    );
  }
}
