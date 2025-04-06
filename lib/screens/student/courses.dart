import 'package:edu_sync/controllers/navigation.dart';
import 'package:edu_sync/screens/student/course_details.dart';
import 'package:edu_sync/widgets/bottom_bar_1.dart';
import 'package:edu_sync/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  int _currentIndex = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final snapshot = await _firestore.collection('subjects').get();
      final subjects =
          snapshot.docs.map((doc) {
            return {
              'id': doc.id,
              'course': doc['name'],
              'image': _getSubjectImage(doc['name']),
              'progress': (doc['progress'] ?? 0).toDouble(),
            };
          }).toList();

      setState(() {
        filteredSubjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading subjects: $e')));
    }
  }

  List<Map<String, dynamic>> filteredSubjects = [];

  String _getSubjectImage(String subjectName) {
    switch (subjectName.toUpperCase()) {
      case 'MATHEMATICS':
        return 'assets/images/math.png';
      case 'SCIENCE':
        return 'assets/images/science.png';
      case 'MUSIC':
        return 'assets/images/music.png';
      case 'ENGLISH':
        return 'assets/images/english.png';
      case 'FRENCH':
        return 'assets/images/french.png';
      case 'ARABIC':
        return 'assets/images/arabic.png';
      case 'COMPUTER':
        return 'assets/images/computer.png';
      case 'ART':
        return 'assets/images/art.png';
      case 'HISTORY':
        return 'assets/images/history.png';
      default:
        return '';
    }
  }

  void searchSubjects(String query) {
    if (query.isEmpty) {
      _loadSubjects();
      return;
    }

    setState(() {
      filteredSubjects =
          filteredSubjects
              .where(
                (subject) => subject['course'].toLowerCase().contains(
                  query.toLowerCase(),
                ),
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
                        delegate: CourseSearch(
                          filteredSubjects,
                          searchSubjects,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.teal,))
                    : filteredSubjects.isEmpty
                    ? const Center(child: Text('No subjects found'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        var subject = filteredSubjects[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CourseDetails(
                                      subjectName: subject['course'],
                                      image: subject['image'],
                                      progress: subject['progress'],
                                    ),
                              ),
                            );
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
