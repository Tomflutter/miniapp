import 'dart:convert';
import 'package:miniapp/data/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentLocalDatasource {
  static const key = 'students';

  Future<void> saveStudent(StudentModel student) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    data.add(jsonEncode(student.toJson()));
    await prefs.setStringList(key, data);
  }

  Future<List<StudentModel>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    return data
        .map((e) => StudentModel.fromJson(jsonDecode(e)))
        .toList();
  }
}
