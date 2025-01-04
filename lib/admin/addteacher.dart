import 'package:flutter/material.dart';

class AddTeacherScreen extends StatelessWidget {
  const AddTeacherScreen({super.key});

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
              _buildTextField(label: 'Full Name'),
              const SizedBox(height: 15),
              _buildTextField(label: 'Email'),
              const SizedBox(height: 15),
              _buildTextField(label: 'Phone Number'),
              const SizedBox(height: 15),
              _buildTextField(label: 'Subject'),
              const SizedBox(height: 15),
              _buildTextField(label: 'Qualifications'),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  // Implement save logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 255, 111, 0), // Orange Button
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Rounded button corners
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

  Widget _buildTextField({required String label}) {
    return TextField(
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
