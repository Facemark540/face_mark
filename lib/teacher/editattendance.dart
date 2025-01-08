import 'package:face_mark/services/firebase_attendence.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  final String studentId;
  final String studentName;

  const AttendanceCalendar({
    required this.studentId,
    required this.studentName,
    Key? key,
  }) : super(key: key);

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _focusedDay = DateTime.now();
  Map<String, bool> _attendance = {}; // Stores attendance for each date

  @override
  void initState() {
    super.initState();
    _fetchAttendance(); // Fetch attendance when the screen initializes
  }

  /// Toggles attendance (present/absent) for a specific day.
  void _toggleAttendance(DateTime day) {
    String dateKey = "${day.year}-${day.month}-${day.day}";
    setState(() {
      // Toggle attendance status or mark as present if not recorded
      if (_attendance.containsKey(dateKey)) {
        _attendance[dateKey] = !_attendance[dateKey]!;
      } else {
        _attendance[dateKey] = true; // Default to present
      }
    });
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

  /// Saves the current attendance data to Firebase.
  Future<void> _saveAttendance() async {
    try {
      await saveAttendance(
        studentId: widget.studentId,
        studentName: widget.studentName,
        attendance: _attendance,
        month: _focusedDay.month.toString(),
        year: _focusedDay.year.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving attendance: $e")),
      );
    }
  }

  /// Returns the color decoration for a given day based on attendance status.
  BoxDecoration _getDayDecoration(DateTime day) {
    String dateKey = "${day.year}-${day.month}-${day.day}";
    if (_attendance.containsKey(dateKey)) {
      // Mark attendance as green (present) or red (absent)
      return BoxDecoration(
        color: _attendance[dateKey]! ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      );
    }
    // Neutral decoration for days with no attendance record
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
          // Calendar to display attendance
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: true, // Show all days, even outside current month
            ),
            calendarBuilders: CalendarBuilders(
              // Custom decoration for each day
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
                _toggleAttendance(selectedDay);
              });
            },
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveAttendance,
              child: const Text("Save Attendance"),
            ),
          ),
        ],
      ),
    );
  }
}
