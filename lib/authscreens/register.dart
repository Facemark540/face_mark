import 'package:face_mark/authscreens/login.dart';
import 'package:face_mark/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  bool isVisible = false;

  void _register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String fullName = fullNameController.text.trim();
    String role = roleController.text.trim().toLowerCase(); // Normalize the role

    String? result;

    // Call the signup function with the additional fields for teacher/student
    if (role == 'teacher') {
      result = await signupUser(email, password, fullName, role, subject: subjectController.text.trim());
    } else if (role == 'student') {
      result = await signupUser(email, password, fullName, role, department: departmentController.text.trim());
    } else {
      result = await signupUser(email, password, fullName, role);
    }

    if (result == null) {
      // Registration successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 53, 126),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField('Full Name', 'Enter your full name', fullNameController),
              const SizedBox(height: 20),
              _buildTextField('Email', 'Enter your email', emailController),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildTextField('Role', 'Enter your role (admin, teacher, student)', roleController),
              const SizedBox(height: 20),

              // Conditionally display the subject or department field
              if (roleController.text.trim().toLowerCase() == 'teacher')
                _buildTextField('Subject', 'Enter your subject', subjectController),
              if (roleController.text.trim().toLowerCase() == 'student')
                _buildTextField('Department', 'Enter your department', departmentController),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _register,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: TextStyle(fontFamily: 'Roboto', color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        TextField(
          controller: passwordController,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: "**********",
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              icon: isVisible
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
