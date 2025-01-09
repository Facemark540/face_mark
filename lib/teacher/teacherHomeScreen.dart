import 'package:face_mark/teacher/uploadImageScreen.dart';
import 'package:face_mark/teacher/viewstudent.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a solid background color (white)
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: [
              // Teacher Dashboard Title
              const Text(
                'Welcome, Teacher!',
                style: TextStyle(
                  fontSize: 36, // Larger title font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color set to black for contrast
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Buttons for actions
              Column(
                children: [
                  // Upload Photo Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      fixedSize: const Size(
                          250, 60), // Fixed size for better alignment
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // More rounded corners
                      ),
                      elevation: 10, // Shadow effect for depth
                      shadowColor:
                          Colors.black, // Shadow color
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UploadImageScreen()));
                    },
                    child: const Text(
                      'Upload Photo',
                      style: TextStyle(
                        fontSize: 20, // Larger text for better visibility
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Button text color set to white
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // View Students Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 40),
                      fixedSize: const Size(
                          250, 60), // Fixed size for better alignment
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // More rounded corners
                      ),
                      elevation: 10, // Shadow effect for depth
                      shadowColor:
                          Colors.black, // Shadow color
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewStudentScreen()));
                    },
                    child: const Text(
                      'View Students',
                      style: TextStyle(
                        fontSize: 20, // Larger text for better visibility
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Button text color set to white
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
