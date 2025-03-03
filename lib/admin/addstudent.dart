


import 'dart:io';
import 'package:face_mark/services/firebase_add_student.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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

  List<File> _selectedImages = [];

  String? _emailError;
  String? _rollNumberError;
  String? _yearError;
  String? _passwordError;
  String? _fullNameError;

  void _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least 3 images")),
      );
      return;
    }

    setState(() {
      _selectedImages = pickedImages.map((e) => File(e.path)).toList();
    });
  }

  bool _validateFields() {
    bool isValid = true;

    if (_fullNameController.text.trim().isEmpty) {
      setState(() {
        _fullNameError = "Full name is required";
      });
      isValid = false;
    }

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

    if (_rollNumberController.text.trim().isEmpty) {
      setState(() {
        _rollNumberError = "Roll number is required";
      });
      isValid = false;
    }

    if (_yearController.text.trim().isEmpty) {
      setState(() {
        _yearError = "Year is required";
      });
      isValid = false;
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = "Password is required";
      });
      isValid = false;
    }

    if (_selectedImages.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least 3 images")),
      );
      isValid = false;
    }

    return isValid;
  }

  Future<void> _uploadImages() async {
    if (!_validateFields()) return;

    var request = http.MultipartRequest('POST', Uri.parse('https://7ed1-2409-4073-201-eec-2b85-aa7c-fdd4-f98.ngrok-free.app/upload'));
    request.fields['rollno'] = _rollNumberController.text;

    for (var image in _selectedImages) {
      request.files.add(await http.MultipartFile.fromPath('files', image.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {

       
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Images uploaded successfully")),
      );
      await addStudentToFirebase(
          fullName: _fullNameController.text,
          email: _emailController.text,
          rollNumber: _rollNumberController.text,
          department: _departmentController.text,
          year: _yearController.text,
          password: _passwordController.text,
          imageFile: null,
        );
      _clearFields();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload failed")),
      );
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
      _selectedImages.clear();
      _emailError = null;
      _rollNumberError = null;
      _yearError = null;
      _passwordError = null;
      _fullNameError = null;
    });
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
              onPressed: _uploadImages,
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
        if (_selectedImages.isNotEmpty)
          Wrap(
            spacing: 10,
            children: _selectedImages.map((file) => Image.file(file, height: 100, width: 100, fit: BoxFit.cover)).toList(),
          )
        else
          const Icon(Icons.person, size: 100, color: Colors.grey),
        TextButton(onPressed: _pickImages, child: const Text('Pick at least 3 Images')),
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























