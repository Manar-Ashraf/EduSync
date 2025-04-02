import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:edu_sync/widgets/search.dart';
import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  int _currentIndex = 1;
  List<Map<String, dynamic>> subjects = [
    {'course': 'MATHEMATICS', 'image': 'assets/images/math.png', 'progress': 0.7},
    {'course': 'SCIENCE', 'image': 'assets/images/science.png', 'progress': 0.6},
    {'course': 'MUSIC', 'image': 'assets/images/music.png', 'progress': 0.9},
    {'course': 'ENGLISH', 'image': 'assets/images/english.png', 'progress': 0.7},
    {'course': 'FRENCH', 'image': 'assets/images/french.png', 'progress': 0.7},
    {'course': 'ARABIC', 'image': 'assets/images/arabic.png', 'progress': 0.8},
    {'course': 'COMPUTER','image': 'assets/images/computer.png','progress': 0.9,},
    {'course': 'ART', 'image': 'assets/images/art.png', 'progress': 0.7},
    {'course': 'HISTORY', 'image': 'assets/images/history.png', 'progress': 0.8},
  ];

  List<Map<String, dynamic>> filteredSubjects = [];

  @override
  void initState() {
    super.initState();
    filteredSubjects = subjects;
  }

  void searchSubjects(String query) {
    setState(() {
      filteredSubjects =
          subjects
              .where(
                (subject) =>
                    subject['course'].contains(query),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 243),
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
                      "My Courses",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CourseSearch(subjects, searchSubjects),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredSubjects.length,
              itemBuilder: (context, index) {
                var subject = filteredSubjects[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CourseDetailsScreen(subjectName: subject['name']),
                    //   ),
                    // );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 185, 215, 215),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              subject['image'],
                              height: 80,
                              width: 90,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 60),

                            Text(
                              subject['course'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: subject['progress'],
                          backgroundColor: Colors.grey[300],
                          color: Color.fromARGB(255, 5, 126, 128),
                          minHeight: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
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
