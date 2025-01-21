import 'dart:io';

import 'package:face_mark/services/firebase_add_student.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class StudentDetailsScreen extends StatefulWidget {
  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Student Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: fetchStudents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No students found'));
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: snapshot.data!.docs.map((document) {
                final data = document.data() as Map<String, dynamic>;
                return _buildDetailCard(
                  docId: document.id,
                  data: data,
                  context: context,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String docId,
    required Map<String, dynamic> data,
    required BuildContext context,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: data['imageUrl'] != null
              ? NetworkImage(data['imageUrl'])
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        title: Text(
          data['fullName'] ?? 'N/A',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 19, 53, 126),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Department: ${data['department'] ?? 'N/A'}'),
            Text('Roll Number: ${data['rollNumber'] ?? 'N/A'}'),
            Text('Year: ${data['year'] ?? 'N/A'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 19, 53, 126)),
              onPressed: () => _showEditDialog(context, docId, data),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.orange),
              onPressed: () async {
                await deleteStudent(docId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student deleted successfully')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, Map<String, dynamic> currentData) {
  final _nameController = TextEditingController(text: currentData['fullName']);
  final _departmentController = TextEditingController(text: currentData['department']);
  final _rollNumberController = TextEditingController(text: currentData['rollNumber']);
  final _yearController = TextEditingController(text: currentData['year']);
  final _passwordController = TextEditingController(text: currentData['password']);
  File? _selectedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (currentData['imageUrl'] != null)
                Image.network(
                  currentData['imageUrl'],
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Change Image'),
              ),
              const SizedBox(height: 10),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: _departmentController, decoration: const InputDecoration(labelText: 'Department')),
              TextField(controller: _rollNumberController, decoration: const InputDecoration(labelText: 'Roll Number')),
              TextField(controller: _yearController, decoration: const InputDecoration(labelText: 'Year')),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await updateStudent(
                  docId: docId,
                  fullName: _nameController.text,
                  department: _departmentController.text,
                  rollNumber: _rollNumberController.text,
                  year: _yearController.text,
                  password: _passwordController.text,
                  imageFile: _selectedImage,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student details updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
}
