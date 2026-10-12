import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../providers/schedule_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Fungsi untuk mengambil data event riil (Jadwal Kuliah & Deadline Tugas) berdasarkan tanggal
  List<dynamic> _getEventsForDay(DateTime day,
      ScheduleProvider scheduleProvider, TaskProvider taskProvider) {
    final List<dynamic> events = [];

    // 1. Ambil Jadwal Kuliah Asli dari ScheduleProvider berdasarkan hari
    final scheduleList = scheduleProvider.getSchedulesByDate(day);
    events.addAll(scheduleList);

    // 2. Ambil Deadline Tugas dari TaskProvider
    final taskList = taskProvider.tasks.where((task) {
      final tDate = task.deadline;
      return tDate.year == day.year &&
          tDate.month == day.month &&
          tDate.day == day.day;
    }).toList();

    events.addAll(taskList);

    return events;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final selectedDayTarget = _selectedDay ?? _focusedDay;
    final selectedEvents =
        _getEventsForDay(selectedDayTarget, scheduleProvider, taskProvider);
    final formattedSelectedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDayTarget);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kontainer Kalender Premium
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  rowHeight: 48,
                  daysOfWeekHeight: 32,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  // Menghubungkan eventLoader dengan data asli dari provider
                  eventLoader: (day) =>
                      _getEventsForDay(day, scheduleProvider, taskProvider),

                  // BUILDER UNTUK MENGATUR DOT (BIRU UNTUK JADWAL, MERAH UNTUK DEADLINE TUGAS)
                  // BUILDER UNTUK MENGATUR DUA DOT (BIRU & MERAH)
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return const SizedBox();

                      // Cek apakah ada Jadwal Kuliah pada hari tersebut
                      final hasSchedule = events.any((event) {
                        return event.runtimeType
                                .toString()
                                .toLowerCase()
                                .contains('schedule') ||
                            event.toString().contains('namaMatkul');
                      });

                      // Cek apakah ada Task (Deadline Tugas) pada hari tersebut
                      final hasTask = events.any((event) {
                        return !event
                                .toString()
                                .toLowerCase()
                                .contains('schedule') &&
                            !event.toString().contains('namaMatkul') &&
                            event.runtimeType
                                .toString()
                                .toLowerCase()
                                .contains('task');
                      });

                      return Positioned(
                        bottom: 6,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dot Biru untuk Jadwal Kuliah
                            if (hasSchedule)
                              Container(
                                width: 4,
                                height: 4,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: const BoxDecoration(
                                  color: Colors
                                      .green, // Ganti jadi hijau yang cerah & jelas
                                  shape: BoxShape.circle,
                                ),
                              ),
                            // Dot Merah untuk Deadline Tugas
                            if (hasTask)
                              Container(
                                width: 4,
                                height: 4,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Styling Header Kalender Pro
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: true,
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black87),
                    formatButtonDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    formatButtonTextStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    leftChevronIcon: const Icon(Icons.chevron_left_rounded,
                        color: AppColors.primary),
                    rightChevronIcon: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.primary),
                  ),

                  // Styling Struktur Hari & Penanda Event
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                        fontSize: 13),
                    weekendStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                        fontSize: 13),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                    weekendTextStyle: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.redAccent),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Header Section Agenda Terpilih
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_today_rounded,
                        color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agenda Tanggal Ini',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:
                                  isDarkMode ? Colors.white : Colors.black87),
                        ),
                        Text(
                          formattedSelectedDate,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Daftar Agenda Riil (Jadwal Kuliah & Tugas)
            selectedEvents.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.03)
                            : Colors.grey.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isDarkMode
                                ? Colors.white10
                                : Colors.grey.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy_rounded,
                              color: Colors.grey.shade400, size: 40),
                          const SizedBox(height: 10),
                          Text(
                            'Tidak ada jadwal atau tugas',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Belum ada agenda pada tanggal yang dipilih ini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      // Pengecekan apakah objek berupa ScheduleModel atau TaskModel
                      final isSchedule = event.runtimeType
                              .toString()
                              .toLowerCase()
                              .contains('schedule') ||
                          event.toString().contains('namaMatkul');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CustomCard(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Theme.of(context).cardColor,
                          child: Row(
                            children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  color: isSchedule
                                      ? AppColors.primary.withOpacity(0.12)
                                      : Colors.red.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isSchedule
                                      ? Icons.school_rounded
                                      : Icons.assignment_rounded,
                                  color: isSchedule
                                      ? AppColors.primary
                                      : Colors.red.shade700,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isSchedule
                                          ? event.namaMatkul
                                          : event.namaTugas,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isSchedule
                                                ? AppColors.primary
                                                    .withOpacity(0.1)
                                                : Colors.red.shade100
                                                    .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isSchedule
                                                ? 'Jadwal Kuliah'
                                                : 'Deadline Tugas',
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: isSchedule
                                                    ? AppColors.primary
                                                    : Colors.red.shade900),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            isSchedule
                                                ? 'Ruangan: ${event.ruangan}'
                                                : 'Matkul: ${event.namaMatkul}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
