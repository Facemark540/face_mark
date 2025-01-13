import 'package:face_mark/admin/adminhomescrn.dart';
import 'package:face_mark/student/studenthomescrn.dart';
import 'package:face_mark/teacher/teacherHomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String?> signupUser(
  String email,
  String password,
  String fullName,
  String role, {
  String? subject,
  String? department,
}) async {
  try {
    // Create user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String userId = userCredential.user!.uid;

    // Normalize role and determine collection
    String normalizedRole = role.toLowerCase();
    String collectionName;

    if (normalizedRole == 'admin') {
      collectionName = 'admin';
    } else if (normalizedRole == 'teacher') {
      collectionName = 'teacher';
    } else if (normalizedRole == 'student') {
      collectionName = 'student';
    } else {
      return 'Invalid role specified';
    }

    // Add user details to the general "users" collection
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'role': normalizedRole,
    });

    // Add user details to the role-specific collection
    Map<String, dynamic> roleSpecificData = {
      'userId': userId,
      'fullName': fullName,
      'email': email,
    };

    if (normalizedRole == 'teacher' && subject != null) {
      roleSpecificData['subject'] = subject;
    } else if (normalizedRole == 'student' && department != null) {
      roleSpecificData['department'] = department;
    }

    await FirebaseFirestore.instance.collection(collectionName).doc(userId).set(roleSpecificData);

    return null; // Sign-up successful
  } catch (e) {
    return e.toString(); // Return error message
  }
}
Future<String?> loginUser(BuildContext context, String email, String password) async {
  try {
    // Sign in user with Firebase Auth
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    String userId = userCredential.user!.uid;

    // Fetch user data from Firestore (the general 'users' collection)
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      String role = userDoc['role'];
      String fullName = userDoc['fullName'];
      String studentId = userDoc['userId'];

      // Check role and handle navigation
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
      } else if (role == 'teacher') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeacherHomeScreen()),
        );
      } else if (role == 'student') {
        // Fetch student-specific data from the 'student' collection
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance.collection('student').doc(userId).get();

        if (studentDoc.exists) {
          // Validate if the student's email and password match the stored details
          String storedEmail = studentDoc['email'];

          if (storedEmail == email) {
            // If credentials match, navigate to the Student Home Screen
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

    return null;
  } catch (e) {
    return e.toString();
  }
}
