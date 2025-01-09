import 'package:face_mark/services/firebase_attendence.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class StudentAttendanceCalendar extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentAttendanceCalendar({
    required this.studentId,
    required this.studentName,
    Key? key,
  }) : super(key: key);

  @override
  State<StudentAttendanceCalendar> createState() => _StudentAttendanceCalendarState();
}

class _StudentAttendanceCalendarState extends State<StudentAttendanceCalendar> {
  DateTime _focusedDay = DateTime.now();
  Map<String, bool> _attendance = {}; // Stores attendance for each date

  @override
  void initState() {
    super.initState();
    _fetchAttendance(); // Fetch attendance when the screen initializes
  }

  /// Fetches attendance from Firebase and updates the UI.
  Future<void> _fetchAttendance() async {
    try {
      var data = await fetchAttendance(widget.studentId);
      if (data != null && data['attendance'] != null) {
        setState(() {
          _attendance = Map<String, bool>.from(data['attendance']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching attendance: $e")),
      );
    }
  }

  /// Returns the color decoration for a given day based on attendance status.
  BoxDecoration _getDayDecoration(DateTime day) {
    String dateKey = "${day.year}-${day.month}-${day.day}";
    if (_attendance.containsKey(dateKey)) {
      return BoxDecoration(
        color: _attendance[dateKey]! ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      );
    }
    return const BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance: ${widget.studentName}'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: true,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: _getDayDecoration(day),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: _getDayDecoration(day),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
        ],
      ),
    );
  }
}
