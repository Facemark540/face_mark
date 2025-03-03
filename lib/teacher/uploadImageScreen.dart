import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HourlyAttendanceScreen extends StatefulWidget {
  const HourlyAttendanceScreen({super.key});

  @override
  State<HourlyAttendanceScreen> createState() => _HourlyAttendanceScreenState();
}

class _HourlyAttendanceScreenState extends State<HourlyAttendanceScreen> {
  // Track attendance status for each hour
  final List<bool> _attendance = [false, false, false, false, false];

  // Track images for each hour
  final List<File?> _hourlyImages = [null, null, null, null, null];

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  XFile? image;

  // Function to handle image selection (camera or gallery)
  Future<void> _selectImage(int hourIndex, ImageSource source) async {
    image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _hourlyImages[hourIndex] = File(image!.path);
      });

      // Upload the image to the API and mark attendance
      await _uploadImageToAPI(File(image!.path), hourIndex);
    }
  }

  // Function to upload image to the API and mark attendance
  Future<void> _uploadImageToAPI(File imageFile, int hourIndex) async {
    const String apiUrl =
        'https://7ed1-2409-4073-201-eec-2b85-aa7c-fdd4-f98.ngrok-free.app/recognize';

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Field name for the file
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // Adjust content type if needed
        ),
      );

      // Send the request
      var response = await request.send();
      print(response.statusCode);

      // Check the response
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        print(jsonResponse);

        // Extract rollno from the API response (assuming it's a list of maps)
        if (jsonResponse is List) {
          for (var item in jsonResponse) {
            String rollno = item['rollno'];
            // Mark attendance in Firestore for each rollno
            await _markAttendance(rollno, hourIndex);
          }
        } else {
          throw Exception('Invalid API response format');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance marked for multiple students'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image for Hour ${hourIndex + 1}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to mark attendance in Firestore
  Future<void> _markAttendance(String rollno, int hourIndex) async {
    try {
      // Get the current user (teacher)
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get the current date
      DateTime now = DateTime.now();
      String dateKey = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      print(rollno);

      // Reference to the student document
      var studentQuery = await _firestore
          .collection('student')
          .where('rollNumber', isEqualTo: rollno)
          .get();

      if (studentQuery.docs.isEmpty) {
        throw Exception('Student with rollno $rollno not found');
      }

      // Save attendance in Firestore
      await _firestore.collection('attendance').add({
        'date': dateKey,
        'hour': hourIndex + 1,
        'rollno': rollno,
        'present': true,
        'teacher_uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance marked for Roll No: $rollno'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error marking attendance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hourly Attendance',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildHourlyAttendanceCard(index + 1);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Save attendance for all hours
          for (int i = 0; i < 5; i++) {
            if (_hourlyImages[i] != null) {
              await _uploadImageToAPI(_hourlyImages[i]!, i);
            }
          }
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  // Build a card for each hour
  Widget _buildHourlyAttendanceCard(int hour) {
    int index = hour - 1; // Convert hour to list index
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hour $hour',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Checkbox(
                  value: _attendance[index],
                  onChanged: (value) {
                    setState(() {
                      _attendance[index] = value ?? false;
                    });
                  },
                  activeColor: Colors.blue.shade800,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _hourlyImages[index] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _hourlyImages[index]!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _selectImage(index, ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectImage(index, ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HourlyAttendanceScreen(),
  ));
}