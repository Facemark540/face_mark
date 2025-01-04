import 'package:face_mark/teacher/editattendance.dart';
import 'package:flutter/material.dart';

class ViewStudentScreen extends StatefulWidget {
  const ViewStudentScreen({super.key});

  @override
  State<ViewStudentScreen> createState() => _ViewStudentScreenState();
}

class _ViewStudentScreenState extends State<ViewStudentScreen> {
  // Sample data for students (you can replace it with actual data)
  final List<Map<String, String>> students = [
    {
      'name': 'Fadhil',
      'roll': 'A123',
      'register': 'R001',
      'image': 'https://www.w3schools.com/w3images/avatar2.png'
    },
    {
      'name': 'Rahil',
      'roll': 'B456',
      'register': 'R002',
      'image': 'https://www.w3schools.com/w3images/avatar6.png'
    },
    // Add more students as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Students'),
        ),
        body: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Circle Avatar for student image
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(student['image']!),
                  ),
                  const SizedBox(width: 16),
                  // Column for name, roll number, and register number
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Roll Number: ${student['roll']}'),
                      Text('Register Number: ${student['register']}'),
                    ],
                  ),
                  const Spacer(),
                  // "View Attendance" button aligned to the right
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAttendanceScreen()));
                      // Action to view attendance (you can navigate to a different screen)
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Center(child: const Text('View')),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
