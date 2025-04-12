import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meyar/EmployeeApplication/CoachPage/Coaches.dart';
import 'package:meyar/EmployeeApplication/CoursesPage/Courses.dart';
import 'package:meyar/EmployeeApplication/CoursesPage/CoursesDetails.dart';
import 'package:meyar/EmployeeApplication/QuizPage/Quiz.dart';
import 'package:meyar/DashBoard/dashboard.dart';
import 'package:meyar/View/RegisterView.dart';
import 'package:meyar/View/VerifyEmail.dart';
import 'package:meyar/View/loginView.dart';
import 'package:meyar/portal.dart';
import 'package:meyar/EmployeeApplication/ProfilePage/profile.dart';
import 'package:meyar/Components/ReRouter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meyar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF2C3E50)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Start with ReRouter to check authentication status
      initialRoute: '/ReRouter',
      routes: {
        // Authentication routes
        '/Login': (context) => const LoginView(),
        '/Register': (context) => const RegisterView(),
        '/VerifyEmail': (context) => const VerifyEmail(),
        '/ReRouter': (context) => const ReRouter(),

        // Main app routes
        '/portal': (context) => const PortalScreen(),
        '/Quiz': (context) => const QuizPage(),
        '/Courses': (context) => const CoursesPage(),
        'CoursesDetails': (context) => CourseDetailsPage(
              course: {},
            ),
        '/Coaches': (context) => const CoachesPage(),
        '/profile': (context) => const ProfilePage(),
        '/dashboard': (context) => HRDashboard(),
      },
    );
  }
}
