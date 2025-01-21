import 'package:face_mark/admin/adminhomescrn.dart';
import 'package:face_mark/student/studenthomescrn.dart';
import 'package:face_mark/teacher/teacherhomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String?> loginUser(BuildContext context, String email, String password) async {
  try {
    // Check if user exists in the admin collection
    QuerySnapshot adminQuery = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (adminQuery.docs.isNotEmpty) {
      var adminData = adminQuery.docs.first.data() as Map<String, dynamic>;
      String storedPassword = adminData['password'];

      // Validate admin password
      if (storedPassword == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
        return null;
      } else {
        return 'Invalid password for admin';
      }
    }

    // Check if user exists in the teacher collection
    QuerySnapshot teacherQuery = await FirebaseFirestore.instance
        .collection('teacher')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (teacherQuery.docs.isNotEmpty) {
      var teacherData = teacherQuery.docs.first.data() as Map<String, dynamic>;
      String storedPassword = teacherData['password'];

      // Validate teacher password
      if (storedPassword == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeacherHomeScreen()),
        );
        return null;
      } else {
        return 'Invalid password for teacher';
      }
    }

    // Otherwise, handle student login using Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    String userId = userCredential.user!.uid;

    // Fetch user data from Firestore
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String role = userDoc['role'];
      String fullName = userDoc['fullName'];
      String studentId = userDoc['userId'];

      if (role == 'student') {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('student')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          String storedEmail = studentDoc['email'];

          if (storedEmail == email) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudentHomeScrn(
                  studentName: fullName,
                  studentEmail: email,
                  studentId: studentId,
                ),
              ),
            );
          } else {
            return 'Invalid credentials for student';
          }
        } else {
          return 'Student data not found';
        }
      } else {
        return 'Unknown role';
      }
    } else {
      return 'User data not found in Firestore';
    }
  } catch (e) {
    return e.toString();
  }
}
