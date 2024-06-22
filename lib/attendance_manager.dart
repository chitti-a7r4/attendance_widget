import 'package:shared_preferences/shared_preferences.dart';
import 'subject.dart';

class AttendanceManager {
  List<Subject> subjects = [];
  static const String SUBJECTS_KEY = 'subjects';

  AttendanceManager() {
    _loadSubjects();
  }

  void _loadSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? subjectsJson = prefs.getStringList(SUBJECTS_KEY);

    if (subjectsJson != null) {
      subjects = subjectsJson
          .map((jsonString) => Subject.fromJsonString(jsonString))
          .toList();
    }
  }

  void _saveSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjectsJson =
        subjects.map((subject) => subject.toJsonString()).toList();
    prefs.setStringList(SUBJECTS_KEY, subjectsJson);
  }

  void addSubject(Subject subject) {
    subjects.add(subject);
    _saveSubjects();
  }

  void deleteSubject(String name) {
    subjects.removeWhere((subject) => subject.name == name);
    _saveSubjects();
  }
}
