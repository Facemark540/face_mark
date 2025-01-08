import 'package:cloud_firestore/cloud_firestore.dart';

/// Saves attendance data for a student.
Future<void> saveAttendance({
  required String studentId,
  required String studentName,
  required Map<String, bool> attendance,
  required String month,
  required String year,
}) async {
  try {
    await FirebaseFirestore.instance.collection('attendance').doc(studentId).set({
      'studentName': studentName,
      'attendance': attendance, // Maps attendance dates to true/false
      'month': month,
      'year': year,
    }, SetOptions(merge: true)); // Merge ensures existing data is retained
    print("Attendance saved successfully!");
  } catch (e) {
    print("Error saving attendance: $e");
    rethrow;
  }
}

/// Fetches attendance data for a student.
Future<Map<String, dynamic>?> fetchAttendance(String studentId) async {
  try {
    var doc = await FirebaseFirestore.instance.collection('attendance').doc(studentId).get();

    if (doc.exists) {
      print("Attendance data fetched successfully.");
      return doc.data(); // Return the entire document as a Map
    } else {
      print("No attendance data found for studentId: $studentId");
      return null;
    }
  } catch (e) {
    print("Error fetching attendance: $e");
    rethrow;
  }
}
