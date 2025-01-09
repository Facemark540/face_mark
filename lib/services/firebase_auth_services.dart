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

    // Fetch user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      String role = userDoc['role'];
      String fullName = userDoc['fullName'];
      String studentId= userDoc['userId'];
      
      // Navigate to the appropriate screen based on the role
      Widget homeScreen;
      if (role == 'admin') {
        homeScreen = const AdminHomeScreen();
      } else if (role == 'teacher') {
        homeScreen = const TeacherHomeScreen();
      } else if (role == 'student') {
        homeScreen = StudentHomeScrn(
          studentName: fullName,  // Pass the full name of the student
          studentEmail: email, studentId: studentId,    // Pass the email of the student
        );
      } else {
        return 'Unknown role';
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homeScreen),
      );
    } else {
      return 'User data not found in Firestore';
    }

    return null;
  } catch (e) {
    return e.toString();
  }
}
