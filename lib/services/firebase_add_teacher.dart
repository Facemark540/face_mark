import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<DocumentReference> addTeacher({
  required String fullName,
  required String email,
  required String phoneNumber,
  required String subject,
  required String qualifications,
  required BuildContext context,
}) async {
 DocumentReference docref= await FirebaseFirestore.instance.collection('teacher').add({
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'subject': subject,
    'qualifications': qualifications,
  });
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Teacher Added Succesfully")));
      return docref;
}


// Fetch all teachers from Firestore
Stream<QuerySnapshot> fetchTeachers() {
  return FirebaseFirestore.instance.collection('teacher').snapshots();
}

// Update a teacher's details in Firestore
Future<void> updateTeacher(String docId, String fullName,String subject,) async {
  await FirebaseFirestore.instance.collection('teacher').doc(docId).update({
    'fullName': fullName,
    'subject': subject,

    
  });
}

// Delete a teacher from Firestore
Future<void> deleteTeacher(String docId) async {
  await FirebaseFirestore.instance.collection('teacher').doc(docId).delete();
}
