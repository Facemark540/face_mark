import 'package:face_mark/services/firebase_attendence.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  final String studentId;
  final String studentName;

  const AttendanceCalendar({
    required this.studentId,
    required this.studentName,
    super.key,
  });

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _focusedDay = DateTime.now();
  Map<String, Map<int, bool>> _attendance = {}; // Stores hourly attendance

  @override
  void initState() {
    super.initState();
    _fetchAttendance(); // Fetch attendance when the screen initializes
  }

  Future<void> _fetchAttendance() async {
    try {
      var data = await fetchAttendance(widget.studentId);
      if (data != null && data['attendance'] != null) {
        setState(() {
          _attendance = Map<String, Map<int, bool>>.from(
            data['attendance'].map((key, value) => MapEntry(
                  key,
                  Map<int, bool>.from(value),
                )),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching attendance: $e")),
      );
    }
  }

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

  void _showHourlyAttendancePopup(DateTime selectedDay) {
    String dateKey = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
    Map<int, bool> hourlyAttendance =
        _attendance[dateKey] ?? Map<int, bool>.fromIterable(List.generate(24, (i) => i), value: (_) => false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hourly Attendance - ${selectedDay.toLocal()}".split(' ')[0]),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, hour) {
                return CheckboxListTile(
                  title: Text("Hour ${hour}:00"),
                  value: hourlyAttendance[hour],
                  onChanged: (value) {
                    setState(() {
                      hourlyAttendance[hour] = value ?? false;
                      _attendance[dateKey] = hourlyAttendance;
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _attendance[dateKey] = hourlyAttendance;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  BoxDecoration _getDayDecoration(DateTime day) {
    String dateKey = "${day.year}-${day.month}-${day.day}";
    if (_attendance.containsKey(dateKey)) {
      bool hasPresentHour = _attendance[dateKey]!.values.contains(true);
      return BoxDecoration(
        color: hasPresentHour ? Colors.green.shade400 : Colors.red.shade400,
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
        title: Text(
          'Attendance: ${widget.studentName}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 53, 126),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 19, 53, 126),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    decoration: _getDayDecoration(day),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
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
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                _showHourlyAttendancePopup(selectedDay);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 19, 53, 126),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Attendance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
