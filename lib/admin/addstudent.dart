import 'package:flutter/material.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back icon
          onPressed: () {
            Navigator.pop(
                context); // Pops the current screen off the navigation stack
          },
        ),
        title: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(
            255, 19, 53, 126), // Dark blue color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            _buildTextField(
              label: 'Student Name',
            ),
            const SizedBox(height: 15),
            _buildTextField(
              label: 'Roll Number',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              label: 'Class',
            ),
            const SizedBox(height: 15),
            _buildTextField(
              label: 'Section',
            ),
            const SizedBox(height: 15),
            _buildTextField(
              label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 255, 111, 0), // Orange button color
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Rounded corners for button
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
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey), // Grey text for labels
        filled: true, // Background of the text field is filled with white
        fillColor: Colors.white, // White background for the text field
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for text field
          borderSide:
              BorderSide(color: Colors.grey.shade300), // Soft grey border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 19, 53, 126)), // Dark blue focused border
        ),
      ),
    );
  }
}
