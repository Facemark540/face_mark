import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_mark/services/firebase_add_student.dart';
import 'package:flutter/material.dart';
import 'package:face_mark/teacher/editattendance.dart';

class ViewStudentScreen extends StatefulWidget {
  const ViewStudentScreen({super.key});

  @override
  State<ViewStudentScreen> createState() => _ViewStudentScreenState();
}

class _ViewStudentScreenState extends State<ViewStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Students'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: fetchStudents(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var students = snapshot.data!.docs;

            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Column for name, roll number, and register number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['fullName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Roll Number: ${student['rollNumber']}'),
                          Text('Department: ${student['department']}'),
                          Text('Year: ${student['year']}'),
                        ],
                      ),
                      const Spacer(),
                      // "View Attendance" button aligned to the right
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceCalendar(
                                studentId: student.id, // Pass the student ID
                                studentName: student[
                                    'fullName'], // Pass the student name
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(child: Text('View')),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
