import 'package:face_mark/admin/studentdetails.dart';
import 'package:face_mark/services/firebase_add_student.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back icon
          onPressed: () {
            Navigator.pop(context); // Pops the current screen off the navigation stack
          },
        ),
        title: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 53, 126), // Dark blue color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            _buildTextField(controller: _fullNameController, label: 'Student Name'),
            const SizedBox(height: 15),
            _buildTextField(controller: _rollNumberController, label: 'Roll Number', keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            _buildTextField(controller: _departmentController, label: 'Department'),
            const SizedBox(height: 15),
            _buildTextField(controller: _yearController, label: 'Year'),
            const SizedBox(height: 15),
            _buildTextField(controller: _emailController, label: 'Email Address', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15),
            _buildTextField(controller: _passwordController, label: 'Password', obscureText: true),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                await addStudent(
                  fullName: _fullNameController.text,
                  email: _emailController.text,
                  rollNumber: _rollNumberController.text,
                  department: _departmentController.text,
                  year: _yearController.text,
                  password: _passwordController.text,  // Added password field
                  context: context,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentDetailsScreen()),
                );

                _fullNameController.clear();
                _emailController.clear();
                _rollNumberController.clear();
                _departmentController.clear();
                _yearController.clear();
                _passwordController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 111, 0), // Orange button color
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners for button
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey), // Grey text for labels
        filled: true, // Background of the text field is filled with white
        fillColor: Colors.white, // White background for the text field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners for text field
          borderSide: BorderSide(color: Colors.grey.shade300), // Soft grey border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 19, 53, 126)), // Dark blue focused border
        ),
      ),
    );
  }
}
