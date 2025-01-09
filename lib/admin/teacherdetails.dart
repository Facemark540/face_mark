import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_mark/services/firebase_add_teacher.dart';
import 'package:flutter/material.dart';

class TeacherDetailsScreen extends StatefulWidget {
  const TeacherDetailsScreen({super.key});

  @override
  _TeacherDetailsScreenState createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Teacher Details',
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
          stream: fetchTeachers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No teachers found'));
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: snapshot.data!.docs.map((document) {
                final data = document.data() as Map<String, dynamic>;
                return _buildDetailCard(
                  docId: document.id,
                  title: data['fullName'] ?? 'N/A',
                  subtitle: data['subject'] ?? 'N/A',
                  qualifications: data['qualifications'] ?? 'N/A',
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
    required String qualifications,
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Qualifications: $qualifications',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _showEditDialog(context, docId, title, subtitle, qualifications);
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
                  await deleteTeacher(docId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Teacher deleted successfully')),
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

  void _showEditDialog(BuildContext context, String docId, String currentName,
      String currentSubject, String currentQualifications) {
    final _nameController = TextEditingController(text: currentName);
    final _subjectController = TextEditingController(text: currentSubject);
    final _qualificationsController =
        TextEditingController(text: currentQualifications);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Teacher'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              TextField(
                controller: _qualificationsController,
                decoration: const InputDecoration(labelText: 'Qualifications'),
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
                await updateTeacher(docId, _nameController.text,
                    _subjectController.text, _qualificationsController.text);
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Teacher details updated successfully')),
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
