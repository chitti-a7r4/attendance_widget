import 'dart:convert';

class Subject {
  final String name;
  int totalClasses = 0;
  int attendedClasses = 0;
  List<DateTime> classDates = []; // List to store class dates

  Subject(this.name);

  void markPresent() {
    totalClasses++;
    attendedClasses++;
  }

  void markAbsent() {
    totalClasses++;
  }

  double get attendancePercentage {
    if (totalClasses == 0) return 0;
    return (attendedClasses / totalClasses) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'classDates': classDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    var subject = Subject(json['name']);
    subject.totalClasses = json['totalClasses'] ?? 0;
    subject.attendedClasses = json['attendedClasses'] ?? 0;
    if (json['classDates'] != null) {
      subject.classDates = List<DateTime>.from(
          json['classDates'].map((dateString) => DateTime.parse(dateString)));
    }
    return subject;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Subject.fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Subject.fromJson(json);
  }

  bool isClassAttended(DateTime date) {
    return classDates.contains(date);
  }
}
