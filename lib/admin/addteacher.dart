import 'package:face_mark/admin/teacherdetails.dart';
import 'package:face_mark/services/firebase_add_teacher.dart';
import 'package:flutter/material.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _qualificationsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _phoneError;
  String? _emailError;
  String? _fullNameError;
  String? _passwordError;

  bool _validateFields() {
    bool isValid = true;

    // Validate Full Name
    if (_fullNameController.text.trim().isEmpty) {
      setState(() {
        _fullNameError = "Full name is required";
      });
      isValid = false;
    }

    // Validate Email
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = "Email is required";
      });
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(_emailController.text)) {
      setState(() {
        _emailError = "Please enter a valid email address";
      });
      isValid = false;
    }

    // Validate Phone Number
    if (_phoneNumberController.text.trim().isEmpty) {
      setState(() {
        _phoneError = "Phone number is required";
      });
      isValid = false;
    } else if (_phoneNumberController.text.length != 10) {
      setState(() {
        _phoneError = "Phone number must be 10 digits";
      });
      isValid = false;
    } else if (int.tryParse(_phoneNumberController.text) == null) {
      setState(() {
        _phoneError = "Phone number must be numeric";
      });
      isValid = false;
    }

    // Validate Password
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = "Password is required";
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Teacher',       ),
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
         foregroundColor: Colors.white, // Set the foreground color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(controller: _fullNameController, label: 'Full Name', errorText: _fullNameError),
              const SizedBox(height: 15),
              _buildTextField(controller: _emailController, label: 'Email', errorText: _emailError),
              const SizedBox(height: 15),
              _buildTextField(controller: _passwordController, label: 'Password', errorText: _passwordError),
              const SizedBox(height: 15),
              _buildTextField(controller: _phoneNumberController, label: 'Phone Number', errorText: _phoneError),
              const SizedBox(height: 15),
              _buildTextField(controller: _subjectController, label: 'Subject'),
              const SizedBox(height: 15),
              _buildTextField(controller: _qualificationsController, label: 'Qualifications'),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  if (_validateFields()) {
                    await addTeacher(
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phoneNumber: _phoneNumberController.text,
                      subject: _subjectController.text,
                      qualifications: _qualificationsController.text,
                      context: context,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TeacherDetailsScreen()),
                    );
                    _clearFields();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fix the errors above.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 111, 0), // Orange Button
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded button corners
                  ),
                ),
                child: const Text(
                  'Save',
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey, // Grey text for labels
        ),
        filled: true,
        fillColor: Colors.white, // White background for text fields
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey), // Grey border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 19, 53, 126), // Dark blue focused border
          ),
        ),
        errorText: errorText, // Display error text if present
      ),
    );
  }

  void _clearFields() {
    _fullNameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _subjectController.clear();
    _qualificationsController.clear();
    _passwordController.clear();
    setState(() {
      _phoneError = null;
      _emailError = null;
      _fullNameError = null;
      _passwordError = null;
    });
  }
}
