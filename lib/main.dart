import 'package:face_mark/admin/addstudent.dart';
import 'package:face_mark/admin/adminhomescrn.dart';
import 'package:face_mark/authscreens/login.dart';
import 'package:face_mark/authscreens/register.dart';
import 'package:face_mark/authscreens/register.dart';
import 'package:face_mark/firebase_options.dart';
import 'package:face_mark/splashscreen.dart';
import 'package:face_mark/student/attendanceScreen.dart';
import 'package:face_mark/student/studenthomescrn.dart';
import 'package:face_mark/teacher/editattendance.dart';
import 'package:face_mark/teacher/teacherHomeScreen.dart';
import 'package:face_mark/teacher/uploadImageScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: AdminHomeScreen(),
    );
  }
}
