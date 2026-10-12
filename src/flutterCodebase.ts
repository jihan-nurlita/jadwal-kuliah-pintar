export const flutterCodebase: Record<string, string> = {
  "pubspec.yaml": `name: jadwal_kuliah_pintar
description: "Aplikasi Jadwal Kuliah Pintar modern untuk mahasiswa"
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.5.3
  go_router: ^16.0.0
  intl: ^0.20.2
  table_calendar: ^3.2.0
  fl_chart: ^1.0.0
  flutter_local_notifications: ^19.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^2.4.9
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
`,

  "lib/core/constants/app_colors.dart": `import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3F51B5);
  static const Color primaryLight = Color(0xFFE8EAF6);
  static const Color accent = Color(0xFFFF4081);
  
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  static const Color textLight = Color(0xFF212121);
  static const Color textDark = Color(0xFFE0E0E0);
  
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  
  static const List<Color> priorityColors = [
    Color(0xFF81C784), // Rendah - Hijau
    Color(0xFFFFB74D), // Sedang - Orange
    Color(0xFFE57373), // Tinggi - Merah
  ];
}
`,

  "lib/core/constants/app_text.dart": `import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle titleSplash = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
  
  static const TextStyle subtitleSplash = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
}
`,

  "lib/core/constants/app_theme.dart": `import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardTheme: const CardTheme(
        color: AppColors.surfaceLight,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardTheme: const CardTheme(
        color: AppColors.surfaceDark,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}
`,

  "lib/core/routes/app_router.dart": `import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/home/dashboard_page.dart';
import '../../presentation/pages/schedule/schedule_page.dart';
import '../../presentation/pages/tasks/tasks_page.dart';
import '../../presentation/pages/calendar/calendar_page.dart';
import '../../presentation/pages/notes/notes_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const SchedulePage(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksPage(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesPage(),
      ),
    ],
  );
}
`,

  "lib/core/utils/date_helper.dart": `import 'package:intl/intl.dart';

class DateHelper {
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH.mm').format(date);
  }
}
`,

  "lib/core/utils/validator.dart": `class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }
}
`,

  "lib/data/models/schedule_model.dart": `import 'package:flutter/material.dart';

class ScheduleModel {
  final String id;
  final String namaMatkul;
  final String dosen;
  final String ruangan;
  final String hari;
  final TimeOfDay mulai;
  final TimeOfDay selesai;

  ScheduleModel({
    required this.id,
    required this.namaMatkul,
    required this.dosen,
    required this.ruangan,
    required this.hari,
    required this.mulai,
    required this.selesai,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'namaMatkul': namaMatkul,
    'dosen': dosen,
    'ruangan': ruangan,
    'hari': hari,
    'mulai_hour': mulai.hour,
    'mulai_minute': mulai.minute,
    'selesai_hour': selesai.hour,
    'selesai_minute': selesai.minute,
  };

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'],
    namaMatkul: json['namaMatkul'],
    dosen: json['dosen'],
    ruangan: json['ruangan'],
    hari: json['hari'],
    mulai: TimeOfDay(hour: json['mulai_hour'], minute: json['mulai_minute']),
    selesai: TimeOfDay(hour: json['selesai_hour'], minute: json['selesai_minute']),
  );
}
`,

  "lib/data/models/task_model.dart": `class TaskModel {
  final String id;
  final String namaTugas;
  final String namaMatkul;
  final DateTime deadline;
  final String prioritas; // 'Rendah', 'Sedang', 'Tinggi'
  final String deskripsi;
  final bool selesai;

  TaskModel({
    required this.id,
    required this.namaTugas,
    required this.namaMatkul,
    required this.deadline,
    required this.prioritas,
    required this.deskripsi,
    required this.selesai,
  });

  TaskModel copyWith({
    String? id,
    String? namaTugas,
    String? namaMatkul,
    DateTime? deadline,
    String? prioritas,
    String? deskripsi,
    bool? selesai,
  }) {
    return TaskModel(
      id: id ?? this.id,
      namaTugas: namaTugas ?? this.namaTugas,
      namaMatkul: namaMatkul ?? this.namaMatkul,
      deadline: deadline ?? this.deadline,
      prioritas: prioritas ?? this.prioritas,
      deskripsi: deskripsi ?? this.deskripsi,
      selesai: selesai ?? this.selesai,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'namaTugas': namaTugas,
    'namaMatkul': namaMatkul,
    'deadline': deadline.toIso8601String(),
    'prioritas': prioritas,
    'deskripsi': deskripsi,
    'selesai': selesai,
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    namaTugas: json['namaTugas'],
    namaMatkul: json['namaMatkul'],
    deadline: DateTime.parse(json['deadline']),
    prioritas: json['prioritas'],
    deskripsi: json['deskripsi'],
    selesai: json['selesai'],
  );
}
`,

  "lib/data/models/note_model.dart": `class NoteModel {
  final String id;
  final String judul;
  final String isiCatatan;
  final DateTime tanggal;
  final String kategori; // 'Pemrograman', 'Basis Data', 'UI/UX', 'Lainnya'

  NoteModel({
    required this.id,
    required this.judul,
    required this.isiCatatan,
    required this.tanggal,
    required this.kategori,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'isiCatatan': isiCatatan,
    'tanggal': tanggal.toIso8601String(),
    'kategori': kategori,
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'],
    judul: json['judul'],
    isiCatatan: json['isiCatatan'],
    tanggal: DateTime.parse(json['tanggal']),
    kategori: json['kategori'],
  );
}
`,

  "lib/data/models/reminder_model.dart": `class ReminderModel {
  final String id;
  final String title;
  final String time; // "HH:MM"
  final bool isActive;
  final String type; // 'Jadwal Kuliah', 'Deadline Tugas', 'Belajar'

  ReminderModel({
    required this.id,
    required this.title,
    required this.time,
    required this.isActive,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'isActive': isActive,
    'type': type,
  };

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json['id'],
    title: json['title'],
    time: json['time'],
    isActive: json['isActive'],
    type: json['type'],
  );
}
`,

  "lib/data/services/hive_service.dart": `import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HiveService {
  // Simulator SharedPreferences untuk kemudahan tanpa setup Native C / Hive binary
  static const String _scheduleKey = 'hive_schedules';
  static const String _tasksKey = 'hive_tasks';
  static const String _notesKey = 'hive_notes';
  static const String _settingsKey = 'hive_settings';

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
`,

  "lib/data/services/notification_service.dart": `import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'jadwal_pintar_channel',
      'Jadwal Pintar Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );
    
    await _notificationsPlugin.show(id, title, body, platformDetails);
  }
}
`,

  "lib/providers/schedule_provider.dart": `import 'package:flutter/material.dart';
import '../data/models/schedule_model.dart';
import '../data/services/hive_service.dart';

class ScheduleProvider with ChangeNotifier {
  List<ScheduleModel> _schedules = [];
  String _searchQuery = '';

  List<ScheduleModel> get schedules {
    if (_searchQuery.isEmpty) return _schedules;
    return _schedules.where((element) => 
        element.namaMatkul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        element.dosen.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
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
      await HiveService.saveSchedules(_schedules.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((e) => e.id == id);
    await HiveService.saveSchedules(_schedules.map((e) => e.toJson()).toList());
    notifyListeners();
  }
}
`,

  "lib/providers/task_provider.dart": `import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/services/hive_service.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  List<TaskModel> get completedTasks => _tasks.where((element) => element.selesai).toList();
  List<TaskModel> get activeTasks => _tasks.where((element) => !element.selesai).toList();

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final rawList = await HiveService.getTasks();
    _tasks = rawList.map((e) => TaskModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addTask(TaskModel item) async {
    _tasks.add(item);
    await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> editTask(TaskModel updatedItem) async {
    final index = _tasks.indexWhere((e) => e.id == updatedItem.id);
    if (index != -1) {
      _tasks[index] = updatedItem;
      await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((e) => e.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(selesai: !_tasks[index].selesai);
      await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((e) => e.id == id);
    await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
    notifyListeners();
  }
}
`,

  "lib/providers/note_provider.dart": `import 'package:flutter/material.dart';
import '../data/models/note_model.dart';
import '../data/services/hive_service.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final rawList = await HiveService.getNotes();
    _notes = rawList.map((e) => NoteModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addNote(NoteModel item) async {
    _notes.add(item);
    await HiveService.saveNotes(_notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> editNote(NoteModel updatedItem) async {
    final index = _notes.indexWhere((e) => e.id == updatedItem.id);
    if (index != -1) {
      _notes[index] = updatedItem;
      await HiveService.saveNotes(_notes.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((e) => e.id == id);
    await HiveService.saveNotes(_notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }
}
`,

  "lib/providers/theme_provider.dart": `import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    notifyListeners();
  }
}
`,

  "lib/main.dart": `import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/routes/app_router.dart';
import 'core/constants/app_theme.dart';
import 'providers/schedule_provider.dart';
import 'providers/task_provider.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'data/services/hive_service.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await HiveService.init();
  await NotificationService.init();
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Jadwal Kuliah Pintar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
`
};
