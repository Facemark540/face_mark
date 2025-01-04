import 'package:face_mark/student/attendanceScreen.dart';
import 'package:flutter/material.dart';

class StudentHomeScrn extends StatefulWidget {
  const StudentHomeScrn({super.key});

  @override
  State<StudentHomeScrn> createState() => _StudentHomeScrnState();
}

class _StudentHomeScrnState extends State<StudentHomeScrn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set a simple white background instead of a gradient
      body: Container(
        color: Colors.white, // Simple white background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Picture (Circle Avatar)
              CircleAvatar(
                radius: 75,
                // backgroundImage: AssetImage('assets/images/profile.jpg'), // Placeholder image
                backgroundColor:
                    Colors.grey[300], // Fallback color if image is missing
              ),
              const SizedBox(height: 20),

              // Student's Name
              Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.black, // Black text for standard readability
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Student's Registration Number
              Text(
                'Regno: 12345678',
                style: TextStyle(
                  color: Colors
                      .black54, // Light black color for the registration number
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              // Attendance Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AttendanceScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // White background for the attendance box
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendance',
                            style: TextStyle(
                              color: Colors.black, // Black text color
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '85% Present',
                            style: TextStyle(
                              color: Colors
                                  .black54, // Light black color for the sub-text
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      // Attendance Progress Bar
                      Container(
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors
                              .green, // Green color for the attendance progress
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.85, // Adjust the progress here (85%)
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
