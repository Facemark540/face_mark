import 'package:flutter/material.dart';

class EditHourlyAttendence extends StatefulWidget {
  final String month;
  final String day;
  final int year;
  EditHourlyAttendence(
      {super.key, required this.day, required this.month, required this.year});

  @override
  State<EditHourlyAttendence> createState() => _EditHourlyAttendenceState();
}

class _EditHourlyAttendenceState extends State<EditHourlyAttendence> {
  List<int> attendedHours = [
    0,
    1,
    1,
    0,
    1
  ]; // Example: 9 AM, 11 AM, 1 PM attended

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
          children: [
            // Hourly Attendance Header
            Text(
              'Hourly Attendance \n${widget.month} ${widget.day}, ${widget.year}',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ListView to show hourly attendance (9 AM to 5 PM)
            Container(
              height: 350, // Set a fixed height for the ListView
              child: ListView.builder(
                itemCount: 5, // From 9 AM to 5 PM (5 time slots)
                itemBuilder: (context, index) {
                  int hour = index + 9; // Hour from 9 AM to 1 PM

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: attendedHours[index] == 1
                          ? Colors.green // Green if attended
                          : Colors.red, // Red if absent
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$hour:00', // Display the hour (9 AM, 10 AM, etc.)
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          attendedHours[index] == 1 ? 'Attended' : 'Absent',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // SizedBox for spacing between ListView and button
            const SizedBox(height: 16),

            // Align the button to the right and apply styling
            Align(
              alignment: Alignment.centerRight, // Align button to the right
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Set the background color to blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Set border radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12), // Optional padding for better button size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
