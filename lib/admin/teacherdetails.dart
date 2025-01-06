import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_mark/services/firebase_add_teacher.dart';
import 'package:flutter/material.dart';

class TeacherDetailsScreen extends StatefulWidget {
  @override
  _TeacherDetailsScreenState createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
        elevation: 0, // Remove AppBar shadow
      ),
      body: Stack(
        children: [
          Container(
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
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final teachers = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return _buildDetailCard(
                      title: teacher['fullName'],
                      subtitle:
                          '${teacher['subject']}',
                      context: context,
                      docId: teacher.id,
                    );
                  },
                );
              },
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String subtitle,
    required BuildContext context,
    required String docId,
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
            style: TextStyle(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 19, 53, 126),
                    size: 26,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  deleteTeacher(docId);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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

  void _showEditDialog(
      BuildContext context, String docId, String currentName, String currentSubject) {
    final _nameController = TextEditingController(text: currentName);
    final _subjectController = TextEditingController(text: currentSubject);

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
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _subjectController,
                 decoration: InputDecoration(labelText: 'Subject'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await updateTeacher(docId, _nameController.text, _subjectController.text);
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data saved successfully')),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
