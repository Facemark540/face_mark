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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Teacher',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            const Color.fromARGB(255, 19, 53, 126), // Dark Blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(controller: _fullNameController, label: 'Full Name'),
              const SizedBox(height: 15),
              _buildTextField(controller: _emailController, label: 'Email'),
              const SizedBox(height: 15),
              _buildTextField(controller: _passwordController, label: 'Password'),
              const SizedBox(height: 15),
              _buildTextField(controller: _phoneNumberController, label: 'Phone Number'),
              const SizedBox(height: 15),
              _buildTextField(controller: _subjectController, label: 'Subject'),
              const SizedBox(height: 15),
              _buildTextField(controller: _qualificationsController, label: 'Qualifications'),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                 await addTeacher(
                    fullName: _fullNameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    phoneNumber: _phoneNumberController.text,
                    subject: _subjectController.text,
                    qualifications: _qualificationsController.text,
                    context: context
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeacherDetailsScreen(
                            
                            )),
                  );
                  _fullNameController.clear();
                  _emailController.clear();
                  _phoneNumberController.clear();
                  _subjectController.clear();
                  _qualificationsController.clear();
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

  Widget _buildTextField({required TextEditingController controller, required String label}) {
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
      ),
    );
  }
}
