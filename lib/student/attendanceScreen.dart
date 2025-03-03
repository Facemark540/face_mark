import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentViewAttendanceScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentViewAttendanceScreen({
    required this.studentId,
    required this.studentName,
    super.key,
  });

  @override
  State<StudentViewAttendanceScreen> createState() => _StudentViewAttendanceScreenState();
}

class _StudentViewAttendanceScreenState extends State<StudentViewAttendanceScreen> {
  DateTime _focusedDay = DateTime.now();
  Map<String, Map<int, bool>> _attendance = {}; // Stores attendance data
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchAttendance(); // Fetch attendance when the screen initializes
  }

  // Fetch attendance data from Firestore
  Future<void> _fetchAttendance() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('rollno', isEqualTo: widget.studentId)
          .get();

      Map<String, Map<int, bool>> attendance = {};
      for (var doc in snapshot.docs) {
        String date = doc['date'];
        int hour = doc['hour'];
        bool present = doc['present'] ?? false;

        if (!attendance.containsKey(date)) {
          attendance[date] = {};
        }
        attendance[date]![hour] = present;
      }

      setState(() {
        _attendance = attendance;
        _isLoading = false; // Data fetching is complete
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching attendance: $e")),
      );
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  // Check if a date has any present hours
  bool _isDatePresent(DateTime day) {
    String dateKey =
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    if (_attendance.containsKey(dateKey)) {
      return _attendance[dateKey]!.values.contains(true);
    }
    return false;
  }


  // Update attendance data in Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance: ${widget.studentName}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(16),
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
                          decoration: _isDatePresent(day)
                              ? BoxDecoration(
                                  color: Colors.green.shade400,
                                  shape: BoxShape.circle,
                                )
                              : const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return Container(
                          decoration: _isDatePresent(day)
                              ? BoxDecoration(
                                  color: Colors.green.shade400,
                                  shape: BoxShape.circle,
                                )
                              : const BoxDecoration(
                                  color: Color.fromARGB(255, 19, 53, 126),
                                  shape: BoxShape.circle,
                                ),
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
                     
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _attendance.length,
                      itemBuilder: (context, index) {
                        String date = _attendance.keys.elementAt(index);
                        Map<int, bool> hours = _attendance[date]!;

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...hours.entries.map((entry) {
                                  int hour = entry.key;
                                  bool present = entry.value;
                                  return ListTile(
                                    title: Text("Hour $hour"),
                                    trailing: present
                                        ? const Icon(Icons.check_circle, color: Colors.green)
                                        : const Icon(Icons.cancel, color: Colors.red),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}