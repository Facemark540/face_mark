import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
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
            letterSpacing: 1.2, // Small letter spacing for elegance
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
        elevation: 0, // Remove AppBar shadow for a cleaner look
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildDetailCard(
              title: 'John Doe',
              subtitle: 'Class: 10\nRoll No: 23',
              context: context,
              imageUrl:
                  'https://www.w3schools.com/w3images/avatar2.png', // Placeholder image
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              title: 'Jane Smith',
              subtitle: 'Class: 9\nRoll No: 34',
              context: context,
              imageUrl:
                  'https://www.w3schools.com/w3images/avatar2.png', // Placeholder image
            ),
            // Add more student details here...
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String subtitle,
    required BuildContext context,
    required String imageUrl,
  }) {
    return Card(
      elevation: 5, // Shadow effect for a raised look
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20), // More rounded corners for the card
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Card tap interaction
          print('Tapped on $title');
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage(imageUrl), // Avatar image for personalization
            radius: 30,
          ),
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
              fontSize: 14,
              color: Colors.grey[600], // Lighter color for subtitle
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  // Edit action
                  print('Edit button tapped');
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
                  // Delete action
                  print('Delete button tapped');
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
}
