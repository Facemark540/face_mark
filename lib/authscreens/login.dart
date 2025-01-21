import 'package:face_mark/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = false;

  // Error messages
  String? emailError;
  String? passwordError;

  // Function to validate inputs
  bool _validateInputs() {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validate email
    if (email.isEmpty) {
      emailError = 'Please enter your email';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      emailError = 'Please enter a valid email address';
    }

    // Validate password
    if (password.isEmpty) {
      passwordError = 'Please enter your password';
    }

    return emailError == null && passwordError == null;
  }

  void _login() async {
    if (_validateInputs()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      String? result = await loginUser(context, email, password);
      if (result == null) {
        // Login successful, redirection handled by loginUser function
      } else {
        // Show error message
        print(result);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    } else {
      // If validation fails, display error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors above.')),
      );
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
                'Login',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 53, 126),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField('Email', 'Enter your email', emailController,
                  error: emailError),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 30),
              // Elevated Button for login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _login, // Call the _login function when pressed
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
        if (passwordError != null)
          Text(
            passwordError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    String? error,
  }) {
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
            errorText: error,
          ),
        ),
        if (error != null)
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
      ],
    );
  }
}
