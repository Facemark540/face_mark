import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<String?> uploadImageToFirebase(File imageFile) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('student_images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  } catch (e) {
    print("Image Upload Error: $e");
    return null;
  }
}

Future<void> addStudentToFirebase({
  required String fullName,
  required String email,
  required String rollNumber,
  required String department,
  required String year,
  required String password,
  required File? imageFile,
}) async {
  try {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImageToFirebase(imageFile);
    }

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('student').doc(userCredential.user!.uid).set({
      'fullName': fullName,
      'email': email,
      'rollNumber': rollNumber,
      'department': department,
      'year': year,
      'role': 'student',
      'imageUrl': imageUrl,
    });

    print("Student Added Successfully");
  } catch (e) {
    print("Error Adding Student: $e");
    rethrow;
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
  required String password,
  File? imageFile, // Add image file parameter
}) async {
  try {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImageToFirebase(imageFile); // Reuse the existing upload function
    }

    Map<String, dynamic> updatedData = {
      'fullName': fullName,
      'department': department,
      'rollNumber': rollNumber,
      'year': year,
      'password': password,
    };

    if (imageUrl != null) {
      updatedData['imageUrl'] = imageUrl; // Include the image URL if a new image is uploaded
    }

    await FirebaseFirestore.instance.collection('student').doc(docId).update(updatedData);
  } catch (e) {
    print("Error updating student: $e");
    rethrow;
  }
}


Future<void> deleteStudent(String docId) async {
  await FirebaseFirestore.instance.collection('student').doc(docId).delete();
}
