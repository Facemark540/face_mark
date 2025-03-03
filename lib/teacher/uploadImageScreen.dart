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
  // Track attendance status for the selected hour
  bool _attendance = false;

  // Track image for the selected hour
  File? _selectedImage;

  // Selected hour from dropdown
  int? _selectedHour;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle image selection (camera or gallery)
  Future<void> _selectImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Upload the image to the API and mark attendance
      if (_selectedHour != null) {
        await _uploadImageToAPI(_selectedImage!, _selectedHour! - 1);
      }
    }
  }

  // Function to upload image to the API and mark attendance
  Future<void> _uploadImageToAPI(File imageFile, int hourIndex) async {
    const String apiUrl = 'https://6bc3-117-213-7-172.ngrok-free.app/recognize';

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Field name for the file
          imageFile.path,
          contentType:
              MediaType('image', 'jpeg'), // Adjust content type if needed
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

      // Get the current date
      DateTime now = DateTime.now();
      String dateKey =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
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
        'teacher_uid': FirebaseAuth.instance.currentUser?.uid,
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
        child: Column(
          children: [
            // Dropdown for hour selection
            DropdownButton<int>(
              value: _selectedHour,
              hint: const Text('Select Hour'),
              items: List.generate(5, (index) => index + 1)
                  .map((hour) => DropdownMenuItem(
                        value: hour,
                        child: Text('Hour $hour'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHour = value;
                  _attendance = false; // Reset attendance status
                  _selectedImage = null; // Reset selected image
                });
              },
            ),
            const SizedBox(height: 20),
            if (_selectedHour != null) _buildAttendanceCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedHour != null && _selectedImage != null) {
            await _uploadImageToAPI(_selectedImage!, _selectedHour! - 1);
          }
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  // Build the attendance card for the selected hour
  Widget _buildAttendanceCard() {
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
                  'Hour $_selectedHour',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Checkbox(
                  value: _attendance,
                  onChanged: (value) {
                    setState(() {
                      _attendance = value ?? false;
                    });
                  },
                  activeColor: Colors.blue.shade800,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
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
                  onPressed: () => _selectImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
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
