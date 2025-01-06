
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<DocumentReference> addStudent({
  required String fullName,
  required String email,
  required String rollNumber,
  required String department,
  required String year,
  required BuildContext context,
}) async {
 DocumentReference docref= await FirebaseFirestore.instance.collection('student').add({
    'fullName': fullName,
    'email': email,
    'rollNumber': rollNumber,
    'department': department,
    'year': year,
  });
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Student Added Succesfully")));
      return docref;
}

  Stream<QuerySnapshot> fetchStudents() {
    return FirebaseFirestore.instance.collection('student').snapshots();
  }

  Future<void> updateStudent(String docId, String fullName, String department) async {
    await FirebaseFirestore.instance.collection('student').doc(docId).update({
      'fullName': fullName,
      'department': department,
    });
  }

  Future<void> deleteStudent(String docId) async {
    await FirebaseFirestore.instance.collection('student').doc(docId).delete();
  }