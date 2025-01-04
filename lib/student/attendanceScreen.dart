import 'package:face_mark/student/hourlyAttendenceScreen.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Example attendance data (days attended by their 1-based index)
  List<int> attendedDays = [2, 5, 8, 12, 15, 18, 21, 25, 28];

  @override
  Widget build(BuildContext context) {
    // Get the current month and year
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    // Calculate the number of days in the current month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Function to get the month name
    String getMonth(int monthNo) {
      switch (monthNo) {
        case 1:
          return 'January';
        case 2:
          return 'February';
        case 3:
          return 'March';
        case 4:
          return 'April';
        case 5:
          return 'May';
        case 6:
          return 'June';
        case 7:
          return 'July';
        case 8:
          return 'August';
        case 9:
          return 'September';
        case 10:
          return 'October';
        case 11:
          return 'November';
        case 12:
          return 'December';
        default:
          return 'January';
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Section
            Text(
              'Attendance Calendar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Calendar Section
            Text(
              '${getMonth(now.month)} / $year',
              style: const TextStyle(color: Colors.black, fontSize: 22),
            ),
            const SizedBox(height: 20),

            // GridView for the Calendar (Days of the Week)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 columns (days of the week)
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount:
                    daysInMonth + 7, // Days of the month + space for titles
                itemBuilder: (context, index) {
                  if (index < 7) {
                    // Display the titles of the days (Sunday, Monday, etc.)
                    return Center(
                      child: Text(
                        getDayName(index),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    );
                  } else {
                    // Calculate the day number (1-based index for the day of the month)
                    int dayOfMonth = index - 7 + 1;

                    // Check if the day is attended
                    bool isAttended = attendedDays.contains(dayOfMonth);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HourlyAttendenceScreen(
                                      day: getDayName(index),
                                      month: getMonth(now.month),
                                      year: now.year,
                                    )));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isAttended ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors
                                .grey, // Adding a subtle border for a clean design
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '$dayOfMonth',
                          style: TextStyle(
                            color: isAttended ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Function to get day name based on index (0: Sunday, 1: Monday, etc.)
  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return '';
    }
  }
}
