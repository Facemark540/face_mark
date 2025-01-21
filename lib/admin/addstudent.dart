import 'dart:io';
import 'package:face_mark/services/firebase_add_student.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'studentdetails.dart';

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

  File? _selectedImage;

  String? _emailError;
  String? _rollNumberError;
  String? _yearError;
  String? _phoneError;
  String? _passwordError;
  String? _fullNameError;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _clearFields() {
    _fullNameController.clear();
    _emailController.clear();
    _rollNumberController.clear();
    _departmentController.clear();
    _yearController.clear();
    _passwordController.clear();
    setState(() {
      _selectedImage = null;
      _emailError = null;
      _rollNumberError = null;
      _yearError = null;
      _phoneError = null;
      _passwordError = null;
      _fullNameError = null;
    });
  }

  bool _validateFields() {
    bool isValid = true;

    // Validate Name
    if (_fullNameController.text.trim().isEmpty) {
      setState(() {
        _fullNameError = "Full name is required";
      });
      isValid = false;
    }

    // Validate Email
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = "Email is required";
      });
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      setState(() {
        _emailError = "Please enter a valid email address";
      });
      isValid = false;
    }

    // Validate Roll Number
    if (_rollNumberController.text.trim().isEmpty) {
      setState(() {
        _rollNumberError = "Roll number is required";
      });
      isValid = false;
    } else if (int.tryParse(_rollNumberController.text.trim()) == null) {
      setState(() {
        _rollNumberError = "Roll number must be a number";
      });
      isValid = false;
    }

    // Validate Year
    if (_yearController.text.trim().isEmpty) {
      setState(() {
        _yearError = "Year is required";
      });
      isValid = false;
    } else if (int.tryParse(_yearController.text.trim()) == null) {
      setState(() {
        _yearError = "Year must be a number";
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

    // Validate Image
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a student image")),
      );
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleSubmit() async {
    if (_validateFields()) {
      try {
        await addStudentToFirebase(
          fullName: _fullNameController.text,
          email: _emailController.text,
          rollNumber: _rollNumberController.text,
          department: _departmentController.text,
          year: _yearController.text,
          password: _passwordController.text,
          imageFile: _selectedImage,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Student Added Successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentDetailsScreen()),
        );

        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix the errors above.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 15),
            _buildTextField(controller: _fullNameController, label: 'Student Name', errorText: _fullNameError),
            const SizedBox(height: 15),
            _buildTextField(controller: _rollNumberController, label: 'Roll Number', keyboardType: TextInputType.number, errorText: _rollNumberError),
            const SizedBox(height: 15),
            _buildTextField(controller: _departmentController, label: 'Department'),
            const SizedBox(height: 15),
            _buildTextField(controller: _yearController, label: 'Year', keyboardType: TextInputType.number, errorText: _yearError),
            const SizedBox(height: 15),
            _buildTextField(controller: _emailController, label: 'Email Address', keyboardType: TextInputType.emailAddress, errorText: _emailError),
            const SizedBox(height: 15),
            _buildTextField(controller: _passwordController, label: 'Password', obscureText: true, errorText: _passwordError),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 111, 0),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_selectedImage != null)
          Image.file(
            _selectedImage!,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
        else
          const Icon(Icons.person, size: 100, color: Colors.grey),
        TextButton(onPressed: _pickImage, child: const Text('Pick an Image')),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        errorText: errorText,
      ),
    );
  }
}
