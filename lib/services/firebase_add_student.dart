import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

Future<void> addStudent({
  required String fullName,
  required String email,
  required String rollNumber,
  required String department,
  required String year,
  required String password,
  required BuildContext context,
}) async {
  try {
    // Create user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Store additional student details in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'fullName': fullName,
      'email': email,
      'rollNumber': rollNumber,
      'department': department,
      'year': year,
      'role': 'student', // Assign role
      'userId':userCredential.user!.uid
    });

    await FirebaseFirestore.instance.collection('student').doc(userCredential.user!.uid).set({
      'fullName': fullName,
      'email': email,
      'rollNumber': rollNumber,
      'department': department,
      'year': year,
      'role': 'student', // Assign role
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Student Added Successfully")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}


Stream<QuerySnapshot> fetchStudents() {
  return FirebaseFirestore.instance.collection('student').snapshots();
}

Future<void> updateStudent({
  required String docId,
  required String fullName,
  required String department,
  required String rollNumber,
  required String year,
  required String password, // Added password field
}) async {
  await FirebaseFirestore.instance.collection('student').doc(docId).update({
    'fullName': fullName,
    'department': department,
    'rollNumber': rollNumber,
    'year': year,
    'password': password, // Update password in Firestore
  });
}

Future<void> deleteStudent(String docId) async {
  await FirebaseFirestore.instance.collection('student').doc(docId).delete();
}
