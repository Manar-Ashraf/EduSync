import 'package:edu_sync/screens/courses.dart';
import 'package:edu_sync/screens/home_student.dart';
import 'package:edu_sync/screens/profile.dart';
import 'package:edu_sync/screens/profile_student.dart';
import 'package:edu_sync/screens/report_student.dart';
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
        '/profile2': (context) => Profile2(),
        '/home_student': (context) => HomeStudent(),
        '/courses': (context) => Courses(),
        '/report': (context) => ReportStudent(),

      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
    );
  }
}
