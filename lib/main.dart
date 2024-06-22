// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'attendance_tile.dart';
import 'subject.dart';
import 'attendance_manager.dart';

void main() => runApp(AttendanceApp());

class AttendanceApp extends StatefulWidget {
  @override
  _AttendanceAppState createState() => _AttendanceAppState();
}

class _AttendanceAppState extends State<AttendanceApp> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Tracker',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: AttendanceHomePage(
        isDarkTheme: isDarkTheme,
        onThemeChanged: (value) {
          setState(() {
            isDarkTheme = value;
          });
        },
      ),
    );
  }
}

class AttendanceHomePage extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  AttendanceHomePage({required this.isDarkTheme, required this.onThemeChanged});

  @override
  _AttendanceHomePageState createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage> {
  AttendanceManager manager = AttendanceManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 31, 101, 108),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade200,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getCurrentDate(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _getCurrentTime(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                      widget.isDarkTheme ? Icons.nights_stay : Icons.wb_sunny),
                  onPressed: () {
                    widget.onThemeChanged(!widget.isDarkTheme);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: manager.subjects.length,
              itemBuilder: (context, index) {
                return AttendanceTile(
                  subject: manager.subjects[index],
                  onDelete: (String name) {
                    setState(() {
                      manager.deleteSubject(name);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewSubject(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return DateFormat.yMMMMd().format(now);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return DateFormat.Hms().format(now);
  }

  void _addNewSubject(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _totalClassesController =
        TextEditingController();
    final TextEditingController _attendedClassesController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Enter subject name'),
              ),
              TextField(
                controller: _totalClassesController,
                decoration: InputDecoration(hintText: 'Enter total classes'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _attendedClassesController,
                decoration: InputDecoration(hintText: 'Enter attended classes'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _totalClassesController.text.isNotEmpty &&
                    _attendedClassesController.text.isNotEmpty) {
                  final String name = _nameController.text;
                  final int totalClasses =
                      int.parse(_totalClassesController.text);
                  final int attendedClasses =
                      int.parse(_attendedClassesController.text);

                  setState(() {
                    Subject newSubject = Subject(name)
                      ..totalClasses = totalClasses
                      ..attendedClasses = attendedClasses;
                    manager.addSubject(newSubject);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
