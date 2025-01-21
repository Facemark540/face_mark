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
    });
  }

  Future<void> _handleSubmit() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 15),
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
