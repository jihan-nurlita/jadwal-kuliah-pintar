import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 1. Tambahkan import intl untuk penerjemahan nama hari
import '../data/models/schedule_model.dart';
import '../data/services/hive_service.dart';

class ScheduleProvider with ChangeNotifier {
  List<ScheduleModel> _schedules = [];
  String _searchQuery = '';

  List<ScheduleModel> get schedules {
    if (_searchQuery.isEmpty) return _schedules;
    return _schedules
        .where((element) =>
            element.namaMatkul
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            element.dosen.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  ScheduleProvider() {
    loadSchedules();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadSchedules() async {
    final rawList = await HiveService.getSchedules();
    _schedules = rawList.map((e) => ScheduleModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addSchedule(ScheduleModel item) async {
    _schedules.add(item);
    await HiveService.saveSchedules(_schedules.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> editSchedule(ScheduleModel updatedItem) async {
    final index = _schedules.indexWhere((e) => e.id == updatedItem.id);
    if (index != -1) {
      _schedules[index] = updatedItem;
      await HiveService.saveSchedules(
          _schedules.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((e) => e.id == id);
    await HiveService.saveSchedules(_schedules.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // 2. Tambahkan fungsi ini agar CalendarPage bisa menyaring jadwal berdasarkan tanggal
  List<ScheduleModel> getSchedulesByDate(DateTime date) {
    // Mendapatkan nama hari dalam bahasa Indonesia (misal: "Senin", "Selasa")
    final dayName = DateFormat('EEEE', 'id_ID').format(date);

    // Normalisasi format huruf kapital di awal
    final formattedDayName = dayName.isNotEmpty
        ? dayName[0].toUpperCase() + dayName.substring(1).toLowerCase()
        : '';

    // Kembalikan daftar jadwal yang harinya cocok
    return _schedules.where((schedule) {
      return schedule.hari.toLowerCase() == formattedDayName.toLowerCase();
    }).toList();
  }
}
