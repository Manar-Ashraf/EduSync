import 'package:edu_sync/screens/instructor/home_instructor.dart';
import 'package:edu_sync/screens/parent/home_parent.dart';
import 'package:edu_sync/screens/student/courses.dart';
import 'package:edu_sync/screens/student/home_student.dart';
import 'package:edu_sync/screens/student/profile_student.dart';
import 'package:edu_sync/screens/student/report.dart';
import 'package:edu_sync/screens/signin.dart';
import 'package:edu_sync/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signin': (context) => Signin(),
        '/signup': (context) => SignUp(),
        '/profile': (context) => Profile(),
        //'/profile2': (context) => Profile2(),
        '/home_student': (context) => HomeStudent(),
        '/courses': (context) => Courses(),
        '/report_student': (context) => ReportStudent(),
        '/home_instructor': (context) => HomeInstructor(),
        '/home_parent': (context) => HomeParent(),

      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
    );
  }
}
