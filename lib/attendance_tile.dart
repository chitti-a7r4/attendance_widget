import 'package:flutter/material.dart';
import 'subject.dart';

class AttendanceTile extends StatefulWidget {
  final Subject subject;
  final Function onDelete;

  AttendanceTile({required this.subject, required this.onDelete});

  @override
  _AttendanceTileState createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  void _markAttendance(bool isPresent) {
    setState(() {
      if (isPresent) {
        widget.subject.markPresent();
      } else {
        widget.subject.markAbsent();
      }
    });
  }

  Color _getTileColor() {
    double percentage = widget.subject.attendancePercentage;

    if (percentage < 50) {
      return Color.fromARGB(255, 239, 39, 24);
    } else if (percentage < 75) {
      return Color.fromARGB(255, 45, 129, 239);
    } else {
      return Colors.green;
    }
  }

  String _getStatusMessage() {
    double percentage = widget.subject.attendancePercentage;

    if (percentage < 50) {
      return 'Go to classes regularly!';
    } else if (percentage < 75) {
      return 'Just a little push!';
    } else {
      return 'Keep up the good work!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getTileColor(),
      child: ListTile(
        title: Text(widget.subject.name),
        subtitle: Text(
          'Attendance: ${widget.subject.attendancePercentage.toStringAsFixed(1)}%',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_getStatusMessage()),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDelete(widget.subject.name);
              },
            ),
          ],
        ),
        onTap: () {
          _showAttendanceDialog(context);
        },
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mark Attendance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  _markAttendance(true);
                  Navigator.of(context).pop();
                },
                child: Text('Present Today'),
              ),
              TextButton(
                onPressed: () {
                  _markAttendance(false);
                  Navigator.of(context).pop();
                },
                child: Text('Absent Today'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Class Not Occurred'),
              ),
            ],
          ),
        );
      },
    );
  }
}
