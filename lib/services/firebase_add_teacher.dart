import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Add a new teacher
Future<DocumentReference> addTeacher({
  required String fullName,
  required String email,
  required String phoneNumber,
  required String subject,
  required String qualifications,
  required String password,
  required BuildContext context,
}) async {
  DocumentReference docref = await FirebaseFirestore.instance.collection('teacher').add({
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'subject': subject,
    'qualifications': qualifications,
    'password': password, 
  });
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Teacher Added Successfully")));
  return docref;
}

// Fetch all teachers from Firestore
Stream<QuerySnapshot> fetchTeachers() {
  return FirebaseFirestore.instance.collection('teacher').snapshots();
}

// Update a teacher's details in Firestore
Future<void> updateTeacher(
    String docId, String fullName, String subject, String qualifications) async {
  await FirebaseFirestore.instance.collection('teacher').doc(docId).update({
    'fullName': fullName,
    'subject': subject,
    'qualifications': qualifications,
  });
}

// Delete a teacher from Firestore
Future<void> deleteTeacher(String docId) async {
  await FirebaseFirestore.instance.collection('teacher').doc(docId).delete();
}
