import 'package:flutter/material.dart';
import 'package:meyar/Courses.dart';
import 'package:meyar/CoursesDetails.dart';
import 'package:meyar/Quiz.dart';
import 'package:meyar/Coaches.dart';
import 'package:meyar/dashboard.dart';
import 'package:meyar/portal.dart';
import 'package:meyar/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meyar',
      home: PortalScreen(),
      routes: {
        '/Quiz': (context) => QuizPage(),
        '/Courses': (context) => CoursesPage(),
        'CoursesDetails': (context) => CourseDetailsPage(
              course: {},
            ),
        '/Coaches': (context) => CoachesPage(),
        '/profile': (context) => ProfilePage(),
        '/dashboard': (context) => HRDashboard(),
        '/portal': (context) => PortalScreen(),
      },
    );
  }
}
