import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HiveService {
  // Simulator SharedPreferences untuk kemudahan tanpa setup Native C / Hive binary
  static const String _scheduleKey = 'hive_schedules';
  static const String _tasksKey = 'hive_tasks';
  static const String _notesKey = 'hive_notes';

  static Future<void> init() async {
    // Dipanggil di main.dart
  }

  static Future<List<Map<String, dynamic>>> getSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_scheduleKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> saveSchedules(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scheduleKey, json.encode(items));
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_tasksKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> saveTasks(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, json.encode(items));
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_notesKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> saveNotes(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, json.encode(items));
  }
}
