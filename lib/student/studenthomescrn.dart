import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_mark/authscreens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:face_mark/student/attendanceScreen.dart';

class StudentHomeScrn extends StatefulWidget {
  final String studentName;
  final String studentEmail;
  final String rollnum;
  final String studentId; // Added studentId for fetching image

  const StudentHomeScrn(
      {super.key,
      required this.studentName,
      required this.studentEmail,
      required this.studentId,
      required this.rollnum});

  @override
  State<StudentHomeScrn> createState() => _StudentHomeScrnState();
}

class _StudentHomeScrnState extends State<StudentHomeScrn> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchStudentImage();
  }

  Future<void> _fetchStudentImage() async {
    try {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentId)
          .get();

      setState(() {
        imageUrl = studentDoc['imageUrl'] as String?; // Fetch image URL
      });
    } catch (e) {
      print("Error fetching image: $e");
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
    // Implement logout functionality here
    // For example, navigate to the login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.orange.shade700,
                      backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl!) // Use the fetched image URL
                          : null,
                      child: imageUrl == null
                          ? const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 80,
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.studentName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.studentEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildCardButton(
                      text: 'Attendance',
                      subtext: 'View Attendance Records',
                      icon: Icons.calendar_today,
                      color: const Color.fromARGB(255, 19, 53, 126),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentViewAttendanceScreen(
                              studentId: widget.rollnum,
                              studentName: widget.studentName,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 19, 53, 126),
            Color.fromARGB(255, 19, 53, 126),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Access your attendance and other details below.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardButton({
    required String text,
    required String subtext,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtext,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: color,
              child: Icon(icon, size: 28, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
