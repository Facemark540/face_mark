import 'package:face_mark/services/firebase_add_student.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Student Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
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
                  title: data['fullName'] ?? 'N/A',
                  subtitle: '${data['department'] ?? 'N/A'}',
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
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          print('Tapped on $title');
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 19, 53, 126),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _showEditDialog(context, docId, title, subtitle);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 19, 53, 126),
                    size: 26,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await deleteStudent(docId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Student deleted successfully')),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.delete,
                    color: Colors.orange,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, String currentName, String currentDepartment) {
    final _nameController = TextEditingController(text: currentName);
    final _departmentController = TextEditingController(text: currentDepartment);
    final _rollNumberController = TextEditingController(text: '');
    final _yearController = TextEditingController(text: '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              TextField(
                controller: _rollNumberController,
                decoration: const InputDecoration(labelText: 'Roll Number'),
              ),
              TextField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await updateStudent(docId, _nameController.text, _departmentController.text, _rollNumberController.text, _yearController.text);
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student details updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
