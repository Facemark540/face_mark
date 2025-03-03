import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentAttendanceScreen({
    required this.studentId,
    required this.studentName,
    super.key,
  });

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
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

  // Show dialog to edit attendance for a specific date
  void _showEditAttendancePopup(DateTime selectedDay) {
    String dateKey =
        "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
    
    // Initialize hourlyAttendance with existing data or default values
    Map<int, bool> hourlyAttendance = _attendance[dateKey] ?? {for (int i = 1; i <= 5; i++) i: false};

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Attendance - ${selectedDay.toLocal()}".split(' ')[0]),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                int hour = index + 1; // Hour ranges from 1 to 5
                return CheckboxListTile(
                  title: Text("Hour $hour"),
                  value: hourlyAttendance[hour],
                  onChanged: (value) {
                    setState(() {
                      hourlyAttendance[hour] = value ?? false;
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
              onPressed: () async {
                await _updateAttendance(dateKey, hourlyAttendance);
                setState(() {
                  _attendance[dateKey] = hourlyAttendance; // Update local state
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

  // Update attendance data in Firestore
  Future<void> _updateAttendance(String dateKey, Map<int, bool> hourlyAttendance) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Fetch existing attendance records for the date
      var snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('date', isEqualTo: dateKey)
          .where('rollno', isEqualTo: widget.studentId)
          .get();

      // Update existing records
      for (var doc in snapshot.docs) {
        int hour = doc['hour'];
        if (hourlyAttendance.containsKey(hour)) {
          await doc.reference.update({
            'present': hourlyAttendance[hour],
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }

      // Add new hours if they don't exist
      for (var hour in hourlyAttendance.keys) {
        if (!snapshot.docs.any((doc) => doc['hour'] == hour)) {
          await FirebaseFirestore.instance.collection('attendance').add({
            'date': dateKey,
            'hour': hour,
            'rollno': widget.studentId,
            'teacher_uid': user.uid,
            'present': hourlyAttendance[hour],
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Attendance updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating attendance: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                      _showEditAttendancePopup(selectedDay);
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